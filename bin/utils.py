# reminescent of bash idiom: cat <<EOF ... EOF > /some/path/name
def cat(contents:str, pn:str)->str:
    # Fix pn if it's a directory to be pn/README.md. Raise an io exception instead?
    if os.path.isdir(pn): pn = os.join(pn, "README.md")
    with open(pn, "w") as f:
        # doesn't dedent?
        f.write(dedent(contents))
    

