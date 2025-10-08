#!/usr/bin/env python3
import re
import subprocess
import sys
import shutil


def clean_boxed_snippet(text: str) -> str:
    cleaned_lines = []
    for line in text.splitlines():
        # remove left/right box edges and whitespace
        # for top border (┌), also remove language identifier
        if "┌" in line:
            line = re.sub(r"^\s*┌\s+\w+\s*─+\s*", "", line)
            line = re.sub(r"\s*─*┐?\s*$", "", line)
        else:
            line = re.sub(r"^\s*[│└┘─]+\s?", "", line)
            line = re.sub(r"\s*[│└┘─]+\s*$", "", line)
        line = line.rstrip()
        if line.strip():
            cleaned_lines.append(line)
    return "\n".join(cleaned_lines)


def read_from_clipboard() -> str:
    if shutil.which("pbpaste"):
        result = subprocess.run("pbpaste", capture_output=True, text=True)
        return result.stdout
    else:
        print("(pbpaste not found — reading from stdin)")
        return sys.stdin.read()


def copy_to_clipboard(text: str):
    if shutil.which("pbcopy"):
        subprocess.run("pbcopy", text=True, input=text)
        print("(copied to clipboard)")
    else:
        print("(pbcopy not found — printing instead)")
        print(text)


if __name__ == "__main__":
    text = read_from_clipboard()
    print("Input:")
    print(text)
    print("\nOutput:")
    cleaned = clean_boxed_snippet(text)
    print(cleaned)
    copy_to_clipboard(cleaned)
