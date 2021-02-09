<h1 align="center">🐗 Brute</h1>
<p align="center">Command line tool for performing brute-force attacks on encrypted HFS+ drives. A Mac is required to run.</p>
<p align="center"></p>
</p>

## Installation

### Homebrew

```console
$ brew tap evanwieland/homebrew-brute
$ brew install brute
```

### Manual installation

```console
$ git clone https://github.com/evanwieland/brute && cd brute
$ export PATH="$PATH:/path/to/dir"
$ chmod +x brute
```
[Crunch](https://sourceforge.net/projects/crunch-wordlist/) and [GNU Parallel](https://www.gnu.org/software/parallel/) are requirements that will also need to be installed manually.

## Usage

```console 
$ sudo brute [drive uuid] [crunch arguments]
```

> IMPORTANT: sudo is required to run Brute. This is due to the `diskutil coreStorage unlockVolume` command being used. If sudo is not used, only 100 attempts to unlock the drive can be made and the machine will need to be restarted.

### Drive UUID

To get your drive UUID, mount the drive and run:

```console 
$ diskutil list
```

The UUID will have the format: ########-####-####-####-############

### Crunch

Brute uses Crunch to generate a wordlist. You can learn more on how to set the crunch arguments by reading [this tutorial](https://null-byte.wonderhowto.com/how-to/tutorial-create-wordlists-with-crunch-0165931/) or the [Crunch man page](http://manpages.ubuntu.com/manpages/bionic/man1/crunch.1.html).

## Example

Below demonstrates unlocking a drive with the password "fun". Obviously, this is an idealized attack and would usually take many, many more attempts.
```sh
$ sudo brute 8A2B552D-1E7F-4089-AA1E-0B709C05D21F 3 3 nfu

Crunch will now generate the following amount of data: 108 bytes
0 MB
0 GB
0 TB
0 PB
Crunch will now generate the following number of lines: 27 
[1] nnn
[2] nnf
[3] nnu
[4] nfn
[5] nff
[6] nfu
[7] nun
[8] nuf
[9] nuu
[10] fnn
[11] fnf
[12] fnu
[13] ffn
[14] fff
parallel: This job succeeded:
cast 16
[15] ffu
[16] fun
[MATCH] fun
[17] fuf
[18] fuu
[19] unn
************************
Password found: fun
************************
```

## Making the attack safer and quicker
To help reduce I/O overhead and wear and tear on the encrypted drive, it is possible to clone the drive to the local drive in order to perform the attack. The steps are as follows:

1. Mount the encrypted drive drive.

2. Run `$ diskutil list` to get the drive identifier.

3. Clone the drive by running `$ sudo dd if=/dev/disk<YOUR_DRIVE_ID> of=Desktop/victim.dmg  bs=2048 conv=sync,notrunc`.

4. To eject the encrypted drive, run `$ diskutil eject /dev/disk<YOUR_DRIVE_ID>`.

5. Mount the cloned drive by running `$ hdiutil attach -noverify -nomount ~/Desktop/victim.dmg`.

## Citation
* [Crunch](https://sourceforge.net/projects/crunch-wordlist/) is used for generating wordlists.
* [GNU Parallel](https://www.gnu.org/software/parallel/) is used for task parallelization.

## Contribution
If you would like to contribute, submit an issue and/or send a PR.

## License
MIT License

Copyright (c) 2021 [Evan Wieland](https://bitsmithy.io)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
