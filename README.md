Release Dashboard
=================

Prerequisites
-------------
1. [Git](http://git-scm.com) 1.7.0+
2. [RVM](http://beginrescueend.com/) 1.10.2+
3. [Ruby](ruby-lang.org/) 1.9.3-p125 (Should be installed via RVM)
4. [Pow](http://pow.cx/) 0.3.2+

More Prerequisites for Mac
--------------------------
1. [Command Line Tools](https://developer.apple.com/downloads/index.action)
2. If you have Xcode 4.2+, you'll want to work around LLVM GCC. Here's [a suggestion](http://www.relaxdiego.com/2012/02/using-gcc-when-xcode-43-is-installed.html).

Installation
------------
1. `git clone https://github.com/relaxdiego/release_dashboard`
2. `cd release_dashboard` (if RVM asks, trust the .rvmrc file)
3. `script/setup`

Usage
-----
1. Point your browser to `http://rd.dev`
2. Learn more about the features by opening `doc/features.html` with your favorite browser

Found a bug?
------------
Report it [here](https://github.com/relaxdiego/release_dashboard/issues).

Getting updates
------------
1. `git pull origin master`
2. `script/setup`

Development
-----------
1. `script/runtests`
2. Start coding using your favorite editor

The tests will run in full, regenerate the code coverage report which is saved in the `coverage` directory, then pause and wait for you to make changes to to the code. When a change is detected, it will run part or all of the tests depending on which part of the code you changed, tell you if the tests passed or failed, then wait for changes. When a change is detected...you get the point now, right?

**Regarding the coverage report:** To speed up testing, the coverage report is re-generated only on startup and when you press `Enter` from the terminal where `sript/runtests` is running. You can tell when the coverage report has been generated by the line 'Coverage report generated for...' that gets displayed in the terminal.

Contributing
------------
1. Fork `https://github.com/relaxdiego/release_dashboard`
2. Create a branch for whatever it is you plan to do
3. Change stuff
4. Send a pull request. If I like it, I will merge to my master branch

Criteria for judging a contribution
-----------------------------------
1. Covered by tests. Use rspec for unit tests and cucumber for integration tests.
2. All tests must pass.

Developer Tips
--------------
1. Before submitting your step definitions, run `cucumber --format usage` to ensure that you are not submitting any unused step definitions.
2. When updating doc/features.html, make sure you press `Enter` while `script/runtests` is running so that the documentation is regenerated in full.

Helpful references for development
----------------------------------
1. [Sinatra](http://www.sinatrarb.com/) - The DSL used for creating the backend of the dashboard
2. [Bootstrap](http://twitter.github.com/bootstrap) - CSS and JS library used to design the UI
3. [jQuery](http://jquery.com/) - Javascript library used to do the AJAXy stuff

License
-------
(The MIT license)

Copyright (c) 2012 Mark S. Maglana

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.