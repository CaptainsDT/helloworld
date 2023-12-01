def registryAdd = "192.168.203.40:80"


pipeline{
    agent {label "jenkins-jenkins-agent"}
    stages{
        stage('拉取代码'){
            steps{
                git branch: 'k8s-dev', url: 'https://jihulab.com/k8s-demo/helloworld.git'
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
                /kaniko/executor --dockerfile=./Dockerfile --context=./ --destination=${registryAdd}/library/helloworld:${BUILD_NUMBER}
                """
            }
        }
        stage('修改tags'){
            steps{
                sh """
                sed -i "s/tags/${BUILD_NUMBER}/g" ./k8s-deployment.yaml
                """
            }
        }
        stage('部署到k8s集群中'){
            steps{
                sh """
                kubectl apply -f k8s-deployment.yaml
                """
            }
        }
    }
}
