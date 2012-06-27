xxdiff.rb
=========

An xxdiff/Subversion integration script in Ruby.

Similar to [xxdiff-subversion](http://xxdiff.sourceforge.net/local/doc/xxdiff-subversion.html). Set variables _diff-cmd_ and _diff3-cmd_ in your _~/.subversion/config_ file to point to _xxdiff.rb_, and ensure that _xxdiff_ and _ruby_ are on your path. When performing a merge, trivial zero-conflict merges will be applied automatically if you set the script's variable _silent_ to _true_.

Unfortunately, when svn performs a merge it passes uninformative filenames to the external diff3 program, so it may not be immediately apparent which file the merge applies to. A [feature request](http://subversion.tigris.org/issues/show_bug.cgi?id=3836) for more helpful filenames has been submitted.

### License

The contents of this repository are released under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0) license. See the LICENSE file for details.

### Thanks
Thanks to Martin Blais for [xxdiff](http://furius.ca/xxdiff/) and [xxdiff-subversion](http://xxdiff.sourceforge.net/local/doc/xxdiff-subversion.html).
