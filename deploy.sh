#Build images and tag each one
docker build -t jlgoh/multi-client:latest -t jlgoh/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jlgoh/multi-server:latest -t jlgoh/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jlgoh/multi-worker:latest -t jlgoh/multi-worker:$SHA -f ./worker/Dockerfile ./worker
#Push the built images to Docker Hub
docker push jlgoh/multi-client:latest
docker push jlgoh/multi-server:latest
docker push jlgoh/multi-worker:latest
docker push jlgoh/multi-client:$SHA 
docker push jlgoh/multi-server:$SHA 
docker push jlgoh/multi-worker:$SHA 
#Apply all configs in the k8s folder
kubectl appply -f k8s
#Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=jlgoh/multi-server:$SHA 
kubectl set image deployments/client-deployment client=jlgoh/multi-client:$SHA 
kubectl set image deployments/worker-deployment worker=jlgoh/multi-worker:$SHA