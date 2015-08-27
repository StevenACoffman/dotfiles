#!/bin/bash
#No time limit
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10

#Last month
#git log --since='last month' --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10
# You can replace the 'last month' with '1 week ago', 'yesterday', '1 year ago', '3 months ago', '1/20/2009'. 
# Or you can omit the --since='last month' to have no time limit.
