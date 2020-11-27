newest() { 
    stat --printf='%Y\t%n\n' $(find $@)|sort -g -r -k1|head -1|cut -f2
}
