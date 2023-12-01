def registryAdd = "192.168.203.40:80/library"
// 命名空间必须存在
def nameSpace = "dolab-namespace"
def appName = "helloworld"
def appServerPort = "8080"
def branchName = "k8s-dev"
// 工作负载类型
def workLoadName = "deploy"

// ${BUILD_NUMBER} jenkins内置环境变量，不修改


pipeline{
    agent {label "jenkins-jenkins-agent"}
    stages{
        stage('拉取代码'){
            steps{
                git branch: "${branchName}", url: 'https://jihulab.com/k8s-demo/helloworld.git'
            }
        }
        stage('构建'){
            steps{
                sh """
                mvn clean package -Dmaven.test.skip=true
                """
            }
        }
        stage('build image and push'){
            steps{
                sh """
                /kaniko/executor --dockerfile=./Dockerfile --context=./ --destination=${registryAdd}/${appName}:${BUILD_NUMBER}
                """
            }
        }
        stage('修改image tags'){
            steps{
                sh """
                sed -i "s/tags/${BUILD_NUMBER}/g" ./k8s-deployment.yaml
                """
            }
        }

        stage('修改命名空间'){
            steps{
                sh """
                sed -i "s/NameSpace/${nameSpace}/g" ./k8s-deployment.yaml
                """
            }

        }

        stage('修改workload name'){
            steps{
                sh """
                sed -i "s/WorkLoadName/${workLoadName}-${appName}/g" ./k8s-deployment.yaml
                """
            }

        }

        stage('部署'){
            steps{
                sh """
                kubectl apply -f k8s-deployment.yaml
                """
            }
        }
    }
}
