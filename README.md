# rethinkdb

 
#build
    docker build -t rethinkdb .

# run as cluster

    docker run -d --name rethinkdb  -p 28015:28015 -p 29015:29015 -p 8080 rastydnb/rethinkdb  --bind all --join <host> 

