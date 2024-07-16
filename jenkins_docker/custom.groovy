import hudson.model.*
import hudson.security.*
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.*
import java.security.SecureRandom
import org.jenkinsci.plugins.matrixauth.AuthorizationType
import org.jenkinsci.plugins.matrixauth.PermissionEntry
import org.jenkinsci.plugins.simpletheme.CssUrlThemeElement
import org.codefirst.SimpleThemeDecorator

def instance = Jenkins.getInstance()
def password = System.getenv("JENKINS_ADMIN_PASSWORD") ?: UUID.randomUUID().toString()
def host = System.getenv("JENKINS_HOSTNAME") ?: InetAddress.localHost.hostAddress.toString()

// Email parameters
def jenkinsParameters = [
  email: "Mr Jenkins <jenkins@${host}>",
  url: "https://${host}/"
]

try {
  // Set Jenkins Admin URL and email
  JenkinsLocationConfiguration jlc = JenkinsLocationConfiguration.get()
  jlc.setUrl(jenkinsParameters.url)
  jlc.setAdminAddress(jenkinsParameters.email)
  jlc.save()
} catch (Exception e) {
  println "--> Jenkins Admin URL and email failed"
  println "${e}"
}

try {
  // Set Hudson Private Security Realm
  def hudsonRealm = new HudsonPrivateSecurityRealm(false)
  hudsonRealm.createAccount('admin', password)
  instance.setSecurityRealm(hudsonRealm)
  instance.setNumExecutors(1)
  instance.setSlaveAgentPort(-1)
  instance.save()
} catch (Exception e) {
  println "--> Hudson Private Security Realm failed"
  println "${e}"
}

try {
  // Set Global Matrix Auth
  def matrix = new GlobalMatrixAuthorizationStrategy()
  matrix.add(Jenkins.ADMINISTER, new PermissionEntry(AuthorizationType.USER, 'admin'))
  instance.setAuthorizationStrategy(matrix)
  instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
  instance.save()
  instance.reload()
} catch (Exception e) {
  println "--> Global Matrix Auth failed"
  println "${e}"
}

try {
  // Update Theme and Style Sheet
  SecureRandom r = new SecureRandom()
  List<String> colours = ['green', 'teal', 'blue', 'grey', 'blue-grey']
  String colour = colours.get(r.nextInt(colours.size()))

  SimpleThemeDecorator theme = instance.getDescriptorByType(SimpleThemeDecorator.class)
  String url = "https://cdn.rawgit.com/afonsof/jenkins-material-theme/gh-pages/dist/material-${colour}.css"
  theme.setElements([new CssUrlThemeElement(url)])

  println "--> updating Jenkins theme to: ${colour}"
} catch (Exception e) {
  println "--> styling failed"
  println "${e}"
}

println "#########################################################"
println "--> IP address ${jenkinsParameters.url}"
println "#########################################################"
