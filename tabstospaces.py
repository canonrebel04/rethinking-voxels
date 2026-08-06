import sys
import os

def format_content(content):
    cbr = 0
    rbr = 0
    ifd = 0
    cleancontent = []
    for line in content:
        ocbr = cbr
        orbr = rbr
        oifd = ifd
        for c in line:
            if c == "{": cbr += 1
            if c == "}": cbr -= 1
            if c == "(": rbr += 1
            if c == ")": rbr -= 1
        line = line.strip()
        if (line[:3] == "#if"):
            ifd += 1
        if (line[:6] == "#endif"):
            ifd -= 1
        if line == "": cleancontent.append("")
        else: cleancontent.append("\t" * (min(cbr, ocbr) + min(rbr, orbr) + min(ifd, oifd)) + line)
    return cleancontent

def main():
    os.system("rm -r tts_tmp")
    os.system("find * -xtype d > filelist.tmp")
    os.system("find * -name '*.glsl' >> filelist.tmp")
    with open("filelist.tmp" ) as lf:
        fnames = lf.readlines()
    dirtree = (".", [])
    os.makedirs("tts_tmp", exist_ok=True)
    for fname in fnames:
        try:
            with open(fname[:-1], "r") as f:
                content = f.readlines()
        except:
            os.makedirs(os.path.join("tts_tmp", fname[:-1]), exist_ok=True)
            continue

        cleancontent = format_content(content)
        with open("tts_tmp/" + fname[:-1], "w") as f:
            f.write("\n".join(cleancontent))

if __name__ == "__main__":
    main()

