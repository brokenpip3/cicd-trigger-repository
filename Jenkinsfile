pipeline {
  triggers {
        cron('H 03 */2 * *')
    }
  agent {
    kubernetes {
      yaml """
kind: Pod
metadata:
  name: needsleep-update
spec:
  containers:
  - name: jnlp
    workingDir: /tmp/jenkins
    resources:
      limits:
        memory: 250Mi
        cpu: 200m
      requests:
        memory: 250Mi
        cpu: 100m
  - name: aurbuild
    workingDir: /tmp/jenkins
    image: brokenpip3/dockerbaseciarch:1.6
    imagePullPolicy: Always
    command:
    - /usr/bin/cat
    tty: true
    resources:
      limits:
        memory: 250Mi
        cpu: 200m
        ephemeral-storage: 800Mi
      requests:
        memory: 250Mi
        cpu: 100m
        ephemeral-storage: 300Mi
    volumeMounts:
      - name: repo-pvc
        mountPath: /srv/repo
  nodeSelector:
    owner: brokenpip3
  imagePullSecrets:
  - name: registry-brokenpip3
  volumes:
  - name: repo-pvc
    persistentVolumeClaim:
      claimName: new-repo-pvc
"""
    }
  }


parameters {
        string(name: 'DEBUG', defaultValue: '', description: '')}

stages {
    stage('Check dep') {
      steps {
          container('aurbuild') {
            sh './check_dep.sh*'
       }}
      }
    stage('Build packages') {
            when {
                expression {
                    return params.DEBUG != 'yes';
                }
              }
        steps {
          container('aurbuild') {
            echo 'Updating or add new packages to repo'
            script {
                def packages = [:]
                env.WORKSPACE = pwd()
                def file = readFile "${env.WORKSPACE}/pkg-depend-list"
                def lines = file.readLines()
                lines.each {
                    packages["package ${it}"] = {
                        build job: '../cicd-build-aurpkg/master', parameters: [[$class: 'StringParameterValue', name: 'PACKAGENAME', value: "$it"]], wait: false
                    }
                }
                parallel packages
            }
        }
    }
}
}
            post {
              always {
                cleanWs()
              }
            }
}
