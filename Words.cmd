echo OFF
cd \aspnet\apiwc
echo -----------------------------------------------------------------
echo [42m   Step 01 - Dotnet Build                                        [0m 
echo -----------------------------------------------------------------
echo [43mdotnet build[0m
dotnet build
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
echo -----------------------------------------------------------------
echo [42m   Step 02 - Docker Build Container                              [0m 
echo -----------------------------------------------------------------
echo [43mdocker build -t apiwc:latest .[0m
docker build -t apiwc:latest .
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
echo -----------------------------------------------------------------
echo [42m   Step 03 - Tag docker image for Bluemix                        [0m 
echo -----------------------------------------------------------------
echo [43mdocker tag apiwc registry.eu-de.bluemix.net/erlcontainers/apiwc:latest[0m
docker tag apiwc registry.eu-de.bluemix.net/erlcontainers/apiwc:latest
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
echo -----------------------------------------------------------------
echo [42m   Step 04 - Push docker image to Bluemix Repositary             [0m 
echo -----------------------------------------------------------------
echo [43mdocker push  --disable-content-trust  registry.eu-de.bluemix.net/erlcontainers/apiwc:latest[0m
docker push registry.eu-de.bluemix.net/erlcontainers/apiwc:latest
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
echo -----------------------------------------------------------------
echo [42m   Step 05 - Delete Kubernetes deployments, Services             [0m 
echo -----------------------------------------------------------------
echo [43mkubectl delete deployments,svc apiwc[0m
kubectl delete deployments,svc apiwc
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
echo -----------------------------------------------------------------
echo [42m   Step 06 - Create Kubernetes deployments, Services             [0m 
echo -----------------------------------------------------------------
echo [43mcreate -f words.yaml[0m
echo [100m
type words.yaml
echo [0m 
kubectl create -f words.yaml
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
rem call \Kubernetes\all.cmd


kubectl get pod
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
rem ping 127.0.0.1 -n 10 > nul
kubectl get pod
IF %ERRORLEVEL% NEQ 0 GOTO ERROR


rem c:\Win2013\ERLAutomation\ERLAutomation\bin\Release\ERLAutomation.exe RFS_Kubernetes
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO END
:ERROR
rem CD \Kubernetes
echo =================================================================
echo [101m                                                                [0m 
echo [101m   Deployment failed...                                         [0m 
echo [101m                                                                [0m 
echo =================================================================
beep.exe alarm
GOTO SLUT
:END
echo =================================================================
echo [42m                                                                [0m 
echo [42m   OK :)                                                        [0m 
echo [42m                                                                [0m 
echo =================================================================
beep.exe ok
rem start chrome "http://159.122.114.35:30100"
:SLUT