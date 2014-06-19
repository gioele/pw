pw: a unix password manager
===========================

pw is a small tool to store password and account data in a safe way.

**BEWARE: pw has not been security reviewed yet. Use with care.**

**pw is currently Linux-only. Could you please help me porting it to
BSD and Mac OSX?**

pw is an alternative to `pass`, `keepassx` and other similar programs.

The main points of pw are:

* The passwords are stored using a simple line-based text format.
* Passwords can be protected using public-key encryption or symmetric
  encryption. Or both.
* No information about the accounts is stored in clear-text.
* All the work is done using only GPG and Unix tools.
* The output is easy to use pipeline with other tools.
* Follows the [XDG Base Directory specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html):
  no clutter in your home directory.


Usage
-----

First you need to tell pw which key should be used to encrypt the data.

    $ echo "GPG_KEY=mel@example.com" > ~/.config/pw

Then you add a password interactively

    $ pw-insert

pw will use `$EDITOR` and present you a template similar to that of
`git commit`.


    # ^^^^ Insert your password as the first line of the file ^^^^
    #
    # Here is a suggestion:
    # 9ECfCUkmiB.$CyZY
    #
    # You can add other fields, one per line. For example:
    #
    # User: mel
    # URL: https://example.org/login
    #
    # Blank lines and lines starting with '#' are ignored

The first line of the file must be the password, the rest of the lines
must be fields in the format "Key: value".

We will use the following data:

    pwFRIENDS
    User: mel@friends.example.net
    URL: http://login.example.net/friends
    PIN: 1923
    Auto-Type: {USERNAME}{TAB}{PASSWORD}{TAB}{FIELD-PIN}{ENTER}

Once you save that files and exit the text editor, pw will store the result
in the default database: `$XDG_DATA_HOME/pw/passwords` (usually
`~/.local/share/pw/passwords`; this is configurable).

Let's add another password, this time with a clear-text label.
(Clear-text label are not required, they can be used if you care
about performance more than you care about your privacy.)

    $ echo "pwOFFICE" | pw-insert --batch --template=- mel@office.example.com

Now let's retrieve the first password:

    $ pw-show mel@friends.example.net
    pwFRIENDS

and the second:

    $ pw-show mel@office.example.com
    pwOFFICE

or all the passwords and their IDs:

    $ pw-show --all
    7135ee6f7e9bb3a32866935ba5bc27362dfaa299  pwFRIENDS
    34c6c91107d2aae2ae64cead56e85cc9a5e0ab40  pwOFFICE


or all the passwords together with all the other data:

    $ pw-show --all --complete
    ID: 7135ee6f7e9bb3a32866935ba5bc27362dfaa299
    Label:
    pwFRIENDS
    User: mel@friends.example.net
    URL: http://login.example.net/friends
    PIN: 1923

    ID: 34c6c91107d2aae2ae64cead56e85cc9a5e0ab40
    Label: mel@office.example.com
    pwOFFICE

or let pw type the password for you:

    $ pw-autotype mel@friends.example.net
    # returns to the previous window, enters username, password, PIN


Composition with other unix tools
---------------------------------

pw has been developed to be readily used with other unix tool using
pipelines.

For example it is possible to write a small script that identifies
all the stored passwords that are shorter than 6 characters.

    pw-show | while read id pass ; do
        [ "${#pass}" -lt 6 ] && echo "Too short" && pw-show -c $id
    done


Multiple databases
------------------

It is possible to store password in multiple databases.
Databases are stored by default in `$XDG_DATA_HOME/pw` (usually
`~/.local/share/pw/`; this is configurable) but can also
be everywhere else.

The `password` database is used by default.

    $ pw-show
    # shows the entries in $XDG_DATA_HOME/pw/passwords

Other databases can be selected using the `--database=FILE` option.

    $ pw-show -d credit-cards
    # shows the entries in $XDG_DATA_HOME/pw/credit-cards

Databases can be stored anywhere.

    $ pw-show -d /home/DevOps-Team/credentials
    # shows the entries in /home/DevOps-Team/credentials


How does pw work? Some information about its format
---------------------------------------------------

pw stores all its data in a password database (you can switch database
using the `--database=FILE` option). Each entry is stored in one line
and is composed of four fields, separated by a colon (`:`):

1. The _version_ information. The first character is the format version
   number, then various letters can follow: `p` for public-key encryption,
   `s` for symmetric encryption, `m` for multiline fields.

2. The clear-text _label_. Used to perform searches without the need to
   decode the encrypted data. It can be empty.

3. The encrypted _blob_. This is the base64-encoded GPG data.

4. The opaque _ID_. The ID of the entry.

An example entry is the following line (split for convenience):

    1p::hQEMA3wI588j6IQ6AQf_Xz4P6jaIwg4Uzf1xlo54jf0cpUpolNQ_7cYv2c17I7N
    E7b4gYHhFmP9gx83MIs_GQwKa2k0iG-oRCWddsLJxWRq655WDJ4qngRhHHni6zoVOB5
    rYUZ6zQIjs2P5r56tSzN8FWI_I2c_VAET9oXM7iZEPQO7C7gHlU-Hh4va-h_nBDZWdN
    vAanbOucmopKFfiwTy7LcHr40d76TzZKnT76IUPY0KtyNxc1XkPUvSYQ0Imx-yBo-hy
    jYkSJXDqIr7eDlMKs7594Crewp59edk_kjW6H5DTuxy91xlGnsIM_aRrsYR_ds9Lj2m
    yCRnb9e-WTNGu9_GG9Z3geJ6YafPuCNI_Ae8vCm-Ad0piOdUll7E1urFQPVFm2GxaNB
    DqjrZpLn4DJuGR2p5o93kHN9i1wccG20Nj9fDoQo9lmyD_zawY:7135ee6f7e9bb3a3
    2866935ba5bc27362dfaa299

* The version information is `1p`;
* there is no clear text label;
* the encrypted blob is `hQEMA3...zaWY`;
* the ID is `7135ee6f7e9bb3a32866935ba5bc27362dfaa299`.


Differences from pass and KeePass
---------------------------------

pw was born because of the following (perceived) limitations of pass and
KeePass.

* pass forces the disclosure of account information. If I can see your
  password store I can understand which accounts have. This is a [real
  concern](http://nms.csail.mit.edu/projects/ssh/) that has [already been
  exploited](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-2666).
* pass knows about git. password managers should not know about what VCS
  tool is used, if any.
* KeePass does not support additional metadata fields.
* Both pass and KeePass produce binary, undiffable files.
* Nor pass neither KeePass follow the XDG Base Directory specification.


Limitations
-----------

Because of the design of the password store, pass has a number of
limitations.

* Search is slower when used without clear-text label because pw needs
  to decipher every entry. With modern computers this is not a real issue.
  In case this is an issue for you, use label and the `--label-only`
  option.
* Labels cannot be composed only of digits.
* Labels cannot include any of the following characters: `:`, `#`, `*`, `\`.


Installation
------------

pw does not have yet a proper installation process.

You can run the files in `bin/` directly or install them in `/usr/local/bin` using

    $ sudo make install


Authors
-------

* Gioele Barabucci <http://svario.it/gioele> (initial author)


Development
-----------

Code
: <http://svario.it/pw> (redirects to GitHub)

Report issues
: <http://svario.it/pw/issues>


Licence
-------

This is free software released into the public domain (CC0 license).

See the `COPYING.CC0` file or <http://creativecommons.org/publicdomain/zero/1.0/>
for more details.
