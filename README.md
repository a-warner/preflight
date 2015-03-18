# Preflight

As software projects and teams grow, it gets more and more difficult for engineers to remember the things they should consider when making changes to the code. This can be partially mitigated by a comprehensive test suite, which will (in many cases) tell engineers when they've broken existing functionality, but a test suite falls short of capturing (at least) the following problems: introduction of security holes, performance regressions, visual bugs and regressions, UX issues, failure to mobile optimize certain pages, and more.

Preflight brings to software development what preflight checklists provided for airline safety: a list of things that every engineer has to think about before marking a pull request as "ready for review". With preflight, you can create checklists for repositories, and, when engineers create new pull requests, the checklists are automatically added to the pull request description.

Unlike testing, preflight checklists won't "break" if someone doesn't look at them. Instead, they are ways of helping engineers avoid common mistakes and regressions. How you use them is up to you and what works best for your team. For certain checklists, you might want to require that engineers "check off" each item to verify that they've done it, like you might want a mechanic to "check off" that they've verified the engine on a plane. For other checklists, you might simply want to list a bunch of things for the engineer to consider, like a list of supported browsers, and leave it up to the engineer's discretion on what he/she thinks is worth checking.

### LICENSE

Copyright (c) 2015 Andrew Warner

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
