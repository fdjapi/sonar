node {
    stage('Build Fresh Image Sonarqube'){
        checkout scm
        def props = readproperties file: 'sonarqube/build.properties'
        sh "wget https://raw.githubusercontent.com/alpinelinux/docker-alpine/v${props.ALPINE_VERSION}/x86_64/Dockerfile -O Dockerfile"
        def ROOTFS = readFile('Dockerfile').readlines()[1].split()[1]
        sh "wget https://github.com/alpinelinux/docker-alpine/raw/v${props.ALPINE_VERSION}/x86_64/${ROOTFS} -O ${ROOTFS}"
        docker.build('fresh')
        docker.withRegistry(props.MSR, props.MSRCREDS){
            docker.build("docker-datacenter/sonarqube:${params.BUILDENV}-${props.SONARQUBE_VERSION}",
            "--build-arg  ALPINE_VERSION=${props.ALPINE_VERSION} \
            --build-arg JAVA_VERSION=${props.JAVA_VERSION} \
            --build-arg SONARQUBE_VERSION=${props.SONARQUBE_VERSION} \
            sonarqube/").push()
        }
    }
}
