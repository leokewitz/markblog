###
                                         _   _    _
                                        | | | |  | |
                  _  _  _    __,   ,_   | | | |  | |  __   __,
                 / |/ |/ |  /  |  /  |  |/_)|/ \_|/  /  \_/  |
                   |  |  |_/\_/|_/   |_/| \_/\_/ |__/\__/ \_/|/
                                                            /|
                                                            \|

The MIT License (MIT)

Copyright (c) 2014 Leonardo Kewitz

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
###

fs = require 'fs'
path = require 'path'
Q = require 'q'
fs_readFile = Q.denodeify fs.readFile
fs_readdir = Q.denodeify fs.readdir
markdown = require('markdown').markdown

Markblog =
	# Compile Post
	compile: (string) ->
		parse = string.match /(?:---\ntitle: )(.*)(?:\ndate: )(.*)(?:\n---\n\n)([^]*)/
		post =
			title: parse[1]
			date: new Date parse[2]
			body:
				html: markdown.toHTML parse[3]
				markdown: parse[3]

	# Read Markdown file.
	read: (file) ->
        fs_readFile file
            .then (data) ->
                md = data.toString()
                post = Markblog.compile md

	# Return all posts compiled.
	readDir: (dir) ->
        fs_readdir (dir)
            .then (files) ->
                promises = files.filter (file) ->
                    file.match /.md/
                .map (file) ->
                    Markblog.read path.join dir, file
                Q.all(promises).then (posts) ->
                    posts

module.exports = Markblog
