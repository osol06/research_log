#! /usr/bin/ruby
# -*- coding: UTF-8 -*-

require 'rubygems'
require 'rsruby'

r = RSRuby.instance
x = Array[1.83,  0.50,  1.62,  2.48, 1.68, 1.88, 1.55, 3.06, 1.30]
y = Array[0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29]
puts x
puts y

e = r.t_test(x, y, paired=TRUE)
puts e

e = r.t_test([1,2,3,4,5,6])
puts e
print e
p e

#x = r.t_test([1.83,  0.50,  1.62,  2.48, 1.68, 1.88, 1.55, 3.06, 1.30])
#puts x
#y = [0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29]
#e = r.t_test(x, y, paired = TRUE, alternative = "greater")
#puts e
#dist = r.rnorm(10, 0, 1)
#puts dist.join(",")
