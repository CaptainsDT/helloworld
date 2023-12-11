def registryAdd = "192.168.203.40:80/library"                   // 镜像地址及仓库
def nameSpace = "dolab-namespace"                               // 命名空间必须存在
def appName = "helloworld"                                      // 服务名字
def branchName = "main"                                     // 服务代码分支，保持与jenkins选择的scm分支一致
def appPath = "hello" 
def ingressAdd = "http://192.168.203.131/"
def emailUser = "760245899@qq.com"                              // 邮件通知，多人接收','分隔
def chartName = "helloworld-chart"

// ${BUILD_NUMBER} jenkins内置环境变量，不修改



pipeline{
    agent {label "jenkins-jenkins-agent"}
    stages{
        stage('git code'){
            steps{
                git branch: "${branchName}", credentialsId: 'gitlab',url: 'https://jihulab.com/k8s-demo/helloworld-go.git'
            }
        }
        stage('code build'){
            steps{
                sh """
                go env -w GOPROXY=https://goproxy.cn,direct
                go build
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

        stage('update Chart Name'){
            steps{
                sh """
                sed -i "s/CHARTNAME/${chartName}/g" ./chart/values.yaml
                """
            }
        }

        stage('update Namespace'){
            steps{
                sh """
                sed -i "s/NAMESPACE/${nameSpace}/g" ./chart/values.yaml
                """
            }
        }

        stage('update App Name'){
            steps{
                sh """
                sed -i "s/APPNAME/${appName}/g" ./chart/values.yaml
                """
            }
        }

        stage('update image'){
            steps{
                sh """
                sed -i "s#IMAGES#${registryAdd}/${appName}-${branchName}#g" ./chart/values.yaml
                sed -i "s#VERSION#v${BUILD_NUMBER}#g" ./chart/values.yaml
                """
            }
        }

        stage('update chart version'){
            steps{
                sh """
                sed -i "s#0.1.0#${BUILD_NUMBER}#g" ./chart/Chart.yaml
                """
            }
        }    

        stage('Check Helm Deployment') {
            steps {
                script {
                    def helmStatus = sh(script: "helm status ${appName} -n ${nameSpace}", returnStatus: true)

                    if (helmStatus == 0) {
                        echo "Helm release ${appName} ${nameSpace} already exists. Upgrading..."
                        // 在这里执行 Helm upgrade 的操作
                        sh "helm upgrade ${appName}  ./chart -n ${nameSpace}"
                    } else {
                        echo "Helm release ${appName} ${nameSpace} does not exist. Installing..."
                        // 在这里执行 Helm install 的操作
                        sh "helm install ${appName} ./chart -n ${nameSpace}"
                    }
                }
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
