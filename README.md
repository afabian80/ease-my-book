# Ease my book
__SYNOPSIS:__ Color and translate hard words in a book based on word frequency lists.

__WARNING:__ This program is supposed to be a better version of my other project, called `coca-hs`, and this is __still under migration__.

This program can turn this content:

![before](https://raw.githubusercontent.com/afabian80/ease-my-book/master/readme/before.png)

to something like this:

![before](https://raw.githubusercontent.com/afabian80/ease-my-book/master/readme/after.png)

The words of your book are compared to a word frequency list of 25 thousand headwords, and the colors are decided based on their frequency in this list.

You have to provide 3 input arguments for this program:
1. The path to an HTML file. (You can convert any book to HTML with Calibre)
2. A number (`A`). This is the Nth thousand block from the BNC-COCA list that you have already learnt. Let's say `A = 4`, which means you know the first 4 thousand words by heart.
3. Another number (`B`). This is your goal for the coming months/years to learn the words up to. Let's say `B = 6`

If you execute the program, it will:
* Leave all words __uncolored__ that can be found in the first `A = 4` thousand words.
* Color all words __green__ that can be found between `A` and `B`.
* Color all words __red__ that are only found between `B` and the end of the frequency list (`25`)
* Color all words __grey__ that are not even found in the frequency list.
* Add __translation__ to the words (using Google Translate, manually at the moment).
* Add the number of __occurrences__ of the word after the translation.

So the execute command is something like this:
```shell
$ runhaskell Main.hs samples/VeryShortStories.htm 4 8
$ open index.html
```

This has several advantages:
* Reading uncolored parts of the book will be easy. And if you find something that you do not understand, you should look it up in a dictionary again.
* You can focus on green words, as you are planning to learn them anyway soon. But you do not need to learn them for now. Take extra attention on very frequent words in your book, shown by high occurrency number.
* You can somewhat ignore red words, as they are quite far from your learning goals. Except if they are relatively frequent in your actual book.
* You can completely ignore grey words, they were not even found in the first 25 thousand words. Although, they are usually proper names, compound words and dirty words.

As soon as the migration from the `coca-hs` repo will be finished, I will also provide a Dockerfile for running this program in environments without Haskell installed properly.
