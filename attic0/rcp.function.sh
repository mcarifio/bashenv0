function rcp { 
    sudo cp -vr $2 $3 
    sudo chown -R $1 $3/$2
}
