pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // 从代码仓库中检出代码
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                // 构建HelloWorld代码，这里假设是使用Maven构建
                sh 'mvn clean package'
            }
        }
        
        stage('Test') {
            steps {
                // 运行测试，如果有的话
                sh 'mvn test'
            }
        }
        
        stage('Deploy') {
            steps {
                // 在这里可以添加部署步骤，比如将构建产物部署到服务器
                echo 'Deploying...'
            }
        }
    }
    
    post {
        success {
            // 构建成功后执行的步骤
            echo 'Build successful! Hello, World!'
        }
        failure {
            // 构建失败后执行的步骤
            echo 'Build failed. Please check the build logs.'
        }
    }
}
