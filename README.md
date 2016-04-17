#chestega-cover

A chess steganography cover generator.

Basically, this generates a .pgn (portable game notation) file
of authenticated games and hides data in said file.

##Installation

I advise you to install chestega-cover in a sandbox.

    cabal sandbox init
    cabal install -j

This will initiate a sandbox and install it there. Three executables
will be installed: chestega-cover, chestega-uncover and chestega-db.
You can find them in .cabal-sandbox/bin.

Next, you should download the latest chestega database from my [github user page](http://joelkarli.github.com).
An alternative is to build your own database using chestega-db.

##Usage

You can use chestega-cover to hide a file in a generated .pgn file. Note, that you should not use this
to hide plain text, you should encrypt the file you want to hide using gpg or another tool.

You can encrypt a file using gpg like so.

    gpg -c input.txt

Then, to hide a file, use chestega-cover.

    chestega-cover input.txt.gpg chestega.db

This will generate a file called input.txt.gpg.pgn. The input.txt.gpg file is hidden in there.
To recover the hidden file, use chestega-uncover.

    chestega-uncover input.txt.gpg.pgn output.txt.gpg

This will create the file output.txt.gpg with the original content of input.txt.gpg.

You can decrypt the output.txt.gpg with gpg.

    gpg output.txt.gpg

###Building your own database

Instead of using the database I provide on my github user page, you can also build or own database.
First, you need some .pgn files of authenticated games. To import the games in your .pgn files into
a database, use chestega-db.

    chestega-db games.pgn data.db

This will create an Sqlite3 database called data.db and insert all the games in games.pgn.