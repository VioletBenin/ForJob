import os

f = open("oracle复习.md", 'a')
filePath = '..\Oracle-BeninViolet\classnotes'
if __name__ == '__main__':
    for i,j,k in os.walk(filePath):
        for o in k:
            s="@import \"" + o + "\"\n"
            f.write(s)

