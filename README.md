# Archived

The author of mac fuse has now released sshfs next version with arm support, so I am archiving this repo

# Mac-Build-Your-Own-SSHFS
This repo will contain code that will allow mac users to build their own copy of sshfs (Without relying on good samitarians to package it further). This gets around the issue where sshfs currently hasn't been updated for years on macfuse official site, and an community build that exists at https://github.com/tormodwill/macSSHFS is reliant on a good samitaritan and currently is intel only. This does allow you to build the one for your system and should be more evergreen. Made this since we currently don't have an easy and clear way to build sshfs on mac, and wanted to do this to allow apple silicon arm builds.


## Caveats
Due to macfuse not supporting libfuse 3.0, we are limited to sshfs 2.10 - however this version is still much better than the one on the macfuse site which is from 2014 and lacks many new additions to sshfs. Should it ever support it, can try to update this to use most recent sshfs - but we'll have to see.

If macfuse also moves away from kernel extenstion to userland, as what is now possible in recent MAC OS versions, this will likely need updated as well. The first time you run it, mac may ask for permissions for underlying macfuse code - I am unable to test this is I have done it for the previous builds.


# Licence Note

All Code not made in this repo carries their original licence. SSHFS 2.10 from https://github.com/libfuse/sshfs/releases/tag/sshfs-2.10
sshfs.c from https://github.com/tormodwill/macSSHFS/commit/46edc02cdc7cca206d80f6af6fb3f083c35f5be3 , a few minor fixes were asked in that repo, and I've carried it forward. 

All code I've written for this is MIT. That is simply the bash script that is to come.


# Requirements

0. [Install Brew if you don't have it](https://brew.sh/)

1. Install [MacFuse ](https://osxfuse.github.io/) - This will require you allow kernel extensions and such. For the build to work, we need libraries this also installs and for the binary to work at all obviously.

2. Install XCode (Maybe if Command Line tools for xcode are not present, brew should install them - but leaving in just in case)

3. `brew install meson ninja glib pkgconfig coreutils` - These packages are required for either the build itself, or ninja

4. Clone this repo

Option 1. 

Do it yourself

1. After cloning the repo, go to it's root folder, cd to sshfs-2.10. 
2. Run the following commands
   * `mkdir _build;cd _build`
   * `meson ..` (if rerunning, `meson .. --reconfigure`)
   * Run `ninja` to compile it, and run the tests. If all should be good, there should be an `sshfs` binary in the _build directory.
   * While this isn't distributable (as in, you cant use it on other macs), this can be used on your system without issue. You can move/copy it to an file on your $PATH to use it as such. Simply using basic alias can be a good option too. 
   * Rebuilding - you may need to delete the sshfs binary, and run meson with reconfigure option. Than run `ninja`. If this doesn't work, just remove the _build folder and retry from the start.

OPTION 2: Bash Script (USE THIS)

-- After cloning, cd to the folder created by git. simply run `sh build_sshfs.sh` `-o` can be used to pass an directory to copy the binary too. `-r 1` can be used to force an rebuild. By default, it will just copy the sshfs binary to the same directory your in.

This will just dump an sshfs binary on your system - move this to an folder in your path, or just call it directly with things like bash alias.

### Notes you likely will need to rebuild between major updates between mac os, and likely all macfuse updates. If you get some sort of error complaining about macfuse linking, this is likely it. Simply rebuilding should fix it. 

# Other helpful tips

by default sshfs will pollute network drives with .DS_Store and for most file systems will also get mac's ._filename files which can pollute servers and be annoying. You can get rid of this by using the -O argument and passing `noapplexattr,noappledouble` ie `sshfs -O noapplexattr,noappledouble`. All of the other standard one sshfs arguments will still apply. 


