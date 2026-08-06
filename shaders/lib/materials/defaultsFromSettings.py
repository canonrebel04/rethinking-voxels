import sys
import os

cwd = os.getcwd()

def walkdir(p):
    contents = list(os.listdir(p))
    files = []
    for c in contents:
        full_path = os.path.join(p, c)
        if os.path.isdir(full_path):
            sub_files = walkdir(full_path)
            files.extend([os.path.join(c, f).replace("\\", "/") for f in sub_files])
        else:
            files.append(c)
    return files

inPlace = False
shaderFileNames = []
settingsFileName = ""
suffix = "_newdefaults"

wrongArgs = False
continueNext = False
for k in range(1, len(sys.argv)):
    if continueNext:
        continueNext = False
        continue
    if sys.argv[k] == "-i": inPlace = True
    elif sys.argv[k] == "-s":
        if settingsFileName != "":
            print("only one settings file is supported!")
            wrongArgs = True
        try:
            settingsFileName = sys.argv[k+1]
            if settingsFileName[0] == "-": wrongArgs = True
            continueNext = True
        except:
            wrongArgs = True
    elif sys.argv[k] == "-a":
        try:
            suffix = sys.argv[k+1]
        except:
            wrongArgs = True
    elif sys.argv[k][0] != "-":
        shaderFileNames.append(sys.argv[k])
    else:
        wrongArgs = True
    if wrongArgs: break
if settingsFileName == "": wrongArgs = True
if wrongArgs:
    print(
"""
Settings to Defaults script by gri573
Usage:
 > python defaultsFromSettings.py [-i] [-a SUFFIX] -s SETTINGS_FILE [CODE FILES]

options:
 -i In-Place Editing
 -s Settings File Name (needs exactly one)
 -a Suffix to append to file name (optional, default: _newdefaults)
 Arguments not preceded by -i, -s or -a will be interpreted as code files.
 Not specifying any code files will cause all contents of the working directory to be treated as code files.
"""
    )
if (inPlace):
    print("Only change default values in-place if you know what you're doing. It is recommended to back up your shaderpack before changing default values in-place because this overwrites shader files.\nDo you know what you are doing? (y/N)")
    response = input()
    if response == "" or not response in "yY":
        print("abort")
        exit()
    else:
        suffix = ""
if shaderFileNames == []:
    shaderFileNames = list(walkdir(cwd))
else:
    shaderFileNames0 = shaderFileNames.copy()
    shaderFileNames = []
    for k in range(len(shaderFileNames0)):
        if os.path.isdir(cwd + "/" + shaderFileNames0[k]):
            shaderFileNames += walkdir(cwd + "/" + shaderFileNames0[k])
        else:
            shaderFileNames.append(shaderFileNames0[k])
settings0 = []
with open(settingsFileName) as settingsFile:
    settings0 = settingsFile.readlines()
settings = {}
for setting in settings0:
    setting = ((setting[:-1]).split("#")[0]).split("=")
    if len(setting) == 2:
        settings[setting[0]] = setting[1]
    elif len(setting) > 2:
        print("Invalid setting: " + "=".join(setting) + "!")
for shaderFileName in shaderFileNames:
    changed = False
    print(shaderFileName)
    shaderFile0 = []
    with open(shaderFileName, "r") as shaderFile:
        shaderFile0 = shaderFile.readlines()
    for k, line in enumerate(shaderFile0):
        i = line.find("#define")
        if i > -1:
            parts = line[i+8:].split(maxsplit=1)
            if parts:
                setting = parts[0]
                if setting in settings:
                    j = len(setting)+i+9
                    if line[i+8:j-1] == setting:
                        if settings[setting] in ("true", "false"):
                            l = line[:i].find("//")
                            if settings[setting] == "true" and l > -1:
                                print(f"Changing {setting} from false to true")
                                shaderFile0[k] = shaderFile0[k][:l] + shaderFile0[k][l+2:]
                                changed = True
                            elif settings[setting] == "false" and l == -1:
                                print(f"Changing {setting} from true to false")
                                shaderFile0[k] = shaderFile0[k][:i] + "//" + shaderFile0[k][i:]
                                changed = True
                        else:
                            oldval = line[j:].split(" ")[0]
                            if oldval != settings[setting]:
                                print(f"Changing {setting} from {oldval} to {settings[setting]}")
                                shaderFile0[k] = shaderFile0[k][:j] + settings[setting] + shaderFile0[k][j+len(oldval):]
                                changed = True
    if changed:
        with open(".".join(shaderFileName.split(".")[:-1]) + suffix + "." + shaderFileName.split(".")[-1], "w") as outFile:
            outFile.write("".join(shaderFile0))