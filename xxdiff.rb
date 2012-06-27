#!/usr/bin/ruby

# Copyright 2012 Paul Madden (maddenp@colorado.edu)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

silent=false # true => apply no-conflict merges silently

require 'tempfile'

a=[] # arguments for xxdiff
f=[] # filenames from svn
t=[] # titles from svn
o=[] # shell command output

# Format titles & filenames for the xxdiff command line.

def tnf(t,f)
  (0..t.size-1).inject("") { |s,i| s+="--title#{i+1} '#{t[i]}' " }+f.join(' ')
end

# Parse the command line. -L arguments are followed by labels, which we store in
# t[] to use as xxdiff titles and also append to a[] (prefixed by -L). Arguments
# with no initial '-' are filenames and are appended to f[]. Other arguments are
# simply appended to a[]. 

ARGV.reverse!
until ARGV.empty?
  a << ARGV.pop
  if a.last=="-L"
    t << ARGV.pop.gsub(/\t+/,' ')
    a << a.pop+' '+t.last
  end
  f << a.last unless a.last=~/^-/
end

# If svn sends three filenames, do a merge; otherwise just diff. For merges, if
# there are no conflicts and diff3 produces a clean merge, use it if silent mode
# is enabled. Otherwise, fix up the titles and call xxdiff, merging to a temp
# file. If the user kills xxdiff without making a decision, exit(1) to trigger
# svn's default conflict handling. If the user merges, accepts or rejects, use
# the output from the temp file.

if f.size==3
  IO.popen("diff3 -mE "+f.join(' ')) { |x| o=x.readlines }
  status=$?>>8
  if $?==0 and silent then
    puts o
    exit(0)
  else
    t.map! { |e| "#{f[1].gsub(/\.tmp$/,'')} #{e.sub(/\.merge-\w+\.|\./,'')}" }
    mf=Tempfile.new("rdiff-mergefile").path
    o=IO.popen("xxdiff -mOM '#{mf}' "+tnf(t,f)).readlines.first
    exit(1) if o=~/NODECISION/
    (o=~/MERGED|ACCEPT|REJECT/)?(puts IO.readlines(mf)):(exit(1))
  end
else
  system "xxdiff #{tnf(t,f)}"
end
