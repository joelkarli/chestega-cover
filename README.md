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