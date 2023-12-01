def registryAdd = "192.168.203.40:80/library"
// 命名空间必须存在
def nameSpace = "dolab-namespace"
def appName = "helloworld"
def branchName = "k8s-dev"
// 工作负载类型
def workLoadName = "deploy"
// 服务请求路径
def appPath = "hello"
// ${BUILD_NUMBER} jenkins内置环境变量，不修改


pipeline{
    agent {label "jenkins-jenkins-agent"}
    stages{
        stage('git code'){
            steps{
                git branch: "${branchName}", url: 'https://jihulab.com/k8s-demo/helloworld.git'
            }
        }
        stage('code build'){
            steps{
                sh """
                mvn clean package -Dmaven.test.skip=true
                """
            }
        }
        stage('build image and push'){
            steps{
                sh """
                /kaniko/executor --dockerfile=./Dockerfile --context=./ --destination=${registryAdd}/${appName}-${branchName}:v${BUILD_NUMBER}
                """
            }
        }
        stage('update image'){
            steps{
                sh """
                sed -i "s#Iamge#${registryAdd}/${appName}-${branchName}:v${BUILD_NUMBER}#g" ./k8s-deployment.yaml
                """
            }
        }

        stage('update namespace'){
            steps{
                sh """
                sed -i "s/NameSpace/${nameSpace}/g" ./k8s-deployment.yaml
                """
            }

        }

        stage('update workload name'){
            steps{
                sh """
                sed -i "s/WorkLoadName/${workLoadName}-${appName}-${branchName}/g" ./k8s-deployment.yaml
                """
            }

        }
        stage('update ingress path'){
            steps{
                sh """
                sed -i "s/Path/${appPath}/g" ./k8s-deployment.yaml
                """
            }

        }

        stage('deploy'){
            steps{
                sh """
                kubectl apply -f k8s-deployment.yaml
                """
            }
        }
    }

    post {
        success {
            emailext (
                subject: "【Jenkins 构建通知,请勿回复!】 项目名称:${env.JOB_NAME}  第 ${env.BUILD_NUMBER} 次更新正常",
                body: """
                详情：
                SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
                状态：${env.JOB_NAME} jenkins 更新运行正常
                URL ：${env.BUILD_URL}
                项目名称 ：${env.JOB_NAME}
                项目更新进度：${env.BUILD_NUMBER}
                """,
                to: "760245899@qq.com",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
                }
        failure {
            emailext (
                subject: "【Jenkins 构建通知,请勿回复!】 项目名称: ${env.JOB_NAME} 第 ${env.BUILD_NUMBER}] 次更新失败",
                body: """
                详情：
                FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
                状态：${env.JOB_NAME} jenkins 运行失败
                URL ：${env.BUILD_URL}
                项目名称 ：${env.JOB_NAME}
                项目更新进度：${env.BUILD_NUMBER}
                """,
                to: "760245899@qq.com",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
                }
    }

}
