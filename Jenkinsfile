def registryAdd = "192.168.203.40:80/library"                   // 镜像地址及仓库
def nameSpace = "dolab-namespace"                               // 命名空间必须存在
def appName = "helloworld"                                      // 服务名字
def branchName = "k8s-dev"                                      // 服务代码分支，保持与jenkins选择的scm分支一致
def workLoadName = "deploy"                                     // 工作负载类型
def appPath = "hello"                                           // 服务请求路径，不加'/'
def appPort = "8080"                                            // 服务端口
def ingressAdd = "http://192.168.203.131/"                      // ingress地址
def emailUser = "760245899@qq.com"                              // 邮件通知，多人接收','分隔
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
        stage('update app port'){
            steps{
                sh """
                sed -i "s/AppPort/${appPort}/g" ./k8s-deployment.yaml
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
                subject: "【DATAOJO Jenkins SUCCESSFUL 构建通知,请勿回复!】 项目名称:${env.JOB_NAME}  第 ${env.BUILD_NUMBER} 次更新正常",
                body: """
                详情：
                SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
                状态：${env.JOB_NAME} jenkins 更新运行正常
                URL ：${env.BUILD_URL}
                项目名称 ：${env.JOB_NAME}
                项目更新进度：${env.BUILD_NUMBER}
                服务访问地址：${ingressAdd}${appPath}
                """,
                to: "${emailUser}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
                }
        failure {
            emailext (
                subject: "【DATAOJO Jenkins FAILED 构建通知,请勿回复!】 项目名称: ${env.JOB_NAME} 第 ${env.BUILD_NUMBER}] 次更新失败",
                body: """
                详情：
                FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
                状态：${env.JOB_NAME} jenkins 运行失败
                URL ：${env.BUILD_URL}
                项目名称 ：${env.JOB_NAME}
                项目更新进度：${env.BUILD_NUMBER}
                """,
                to: "${emailUser}",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
                }
    }

}
