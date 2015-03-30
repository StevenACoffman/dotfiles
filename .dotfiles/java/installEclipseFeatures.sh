#!/bin/bash
exit 1
# eclipse
repoUrls=http://download.eclipse.org/releases/luna
repoUrls=$repoUrls,http://download.sigasi.com/update/mousefeed/
repoUrls=$repoUrls,http://moreunit.sourceforge.net/update-site/

#repoUrls=http://download.eclipse.org/egit/updates
repoUrls=$repoUrls,http://download.eclipse.org/releases/luna
#repoUrls=http://download.eclipse.org/m2e-wtp/releases/luna/1.1
#repoUrls=http://download.eclipse.org/mylyn/releases/luna
#repoUrls=http://dist.springsource.com/release/TOOLS/update/e4.4/
#repoUrls=http://download.eclipse.org/eclipse/updates/4.4/
#repoUrls=http://download.eclipse.org/webtools/repository/luna
#repoUrls=http://download.eclipse.org/mylyn/releases/3.12
#repoUrls=http://download.eclipse.org/webtools/updates
#repoUrls=http://eclipse.tmatesoft.com/svnkit/1.8.x/


p2StatsURI=http://download.eclipse.org/stats/webtools/repository${STATS_TAG_VERSIONINDICATOR}
statsArtifactsSuffix="${STATS_TAG_SUFFIX}"
statsTrackedArtifacts=org.eclipse.wst.jsdt.feature,org.eclipse.wst.xml_ui.feature, \
   org.eclipse.wst.web_ui.feature,org.eclipse.jst.enterprise_ui.feature


repoUrls=http://download.eclipse.org/releases/indigo,http://download.eclipse.org/eclipse/updates/3.7,http://download.eclipse.org/eclipse/updates/3.6,http://download.eclipse.org/eclipse/updates/3.5,http://download.eclipse.org/eclipse/updates/3.4
repoUrls=$repoUrls,http://www.eclipse.org/modeling/emf/updates/,http://download.eclipse.org/modeling/emf/updates/releases/
repoUrls=$repoUrls,http://download.eclipse.org/birt/update-site/2.6
repoUrls=$repoUrls,http://download.eclipse.org/webtools/repository/indigo
repoUrls=$repoUrls,http://download.eclipse.org/tools/gef/updates/releases/
repoUrls=$repoUrls,http://download.eclipse.org/technology/dltk/updates
repoUrls=$repoUrls,http://download.eclipse.org/tools/cdt/releases/indigo

#scala
#repoUrls=$repoUrls,http://download.scala-ide.org/nightly-update-wip-exp-backport-2.8.1.final
repoUrls=$repoUrls,http://download.scala-ide.org/releases-29/stable/site
features=org.scala-ide.sdt.feature.feature.group,org.scala-ide.sdt.weaving.feature.feature.group,org.scala-ide.sdt.source.feature.feature.group
#http://download.scala-ide.org/releases/2.0.0-beta

# pydev
repoUrls=$repoUrls,http://pydev.org/updates
features=$features,org.python.pydev.feature.feature.group,org.python.pydev.mylyn.feature.feature.group

#groovy
#features=$features,org.codehaus.groovy.eclipse.feature.feature.group

#glance
repoUrls=$repoUrls,http://eclipse-glance.googlecode.com/svn/site
features=$features,com.xored.glance.ui.feature.feature.group

# mechanic
repoUrls=$repoUrls,http://workspacemechanic.eclipselabs.org.codespot.com/git.update/mechanic
features=$features,com.google.eclipse.mechanic.feature.group

# m2eclipse
#repoUrls=$repoUrls,http://m2eclipse.sonatype.org/sites/m2e,http://m2eclipse.sonatype.org/sites/m2e-extras
repoUrls=$repoUrls,http://download.eclipse.org/technology/m2e/releases
#features=$features,org.maven.ide.eclipse.feature.feature.group,org.maven.ide.eclipse.subclipse.feature.feature.group,org.sonatype.tycho.m2e.feature.feature.group
features=$features,org.eclipse.m2e.feature.feature.group,org.eclipse.m2e.logback.feature.feature.group


# subclipse
repoUrls=$repoUrls,http://subclipse.tigris.org/update_1.6.x
features=$features,com.collabnet.subversion.merge.feature.feature.group,com.sun.jna.feature.group,org.tigris.subversion.clientadapter.feature.feature.group,org.tigris.subversion.clientadapter.javahl.feature.feature.group,org.tigris.subversion.clientadapter.svnkit.feature.feature.group,org.tigris.subversion.subclipse.feature.group,org.tigris.subversion.subclipse.graph.feature.feature.group,org.tigris.subversion.subclipse.mylyn.feature.group,org.tmatesoft.svnkit.feature.group

# egit
repoUrls=$repoUrls,http://download.eclipse.org/egit/updates
features=$features,org.eclipse.egit.feature.group,org.eclipse.jgit.feature.group

# mercurial
repoUrls=$repoUrls,http://mercurialeclipse.eclipselabs.org.codespot.com/hg.wiki/update_site/stable
features=$features,mercurialeclipse.feature.group

# dltk
features=$features,org.eclipse.dltk.core.feature.group

# ruby
features=$features,org.eclipse.dltk.ruby.feature.group

# geppetto
repoUrls=$repoUrls,http://download.cloudsmith.com/geppetto/updates
features=$features,org.cloudsmith.geppetto.feature.group

# mylyn
#repoUrls=$repoUrls,http://download.eclipse.org/tools/mylyn/update/e3.4
repoUrls=$repoUrls,http://download.eclipse.org/mylyn/releases/latest
features=$features,org.eclipse.mylyn.builds.feature.group,org.eclipse.mylyn.commons.feature.group,org.eclipse.mylyn.context_feature.feature.group,org.eclipse.mylyn.git.feature.group,org.eclipse.mylyn.htmltext.feature.group,org.eclipse.mylyn.hudson.feature.group,org.eclipse.mylyn.ide_feature.feature.group,org.eclipse.mylyn.java_feature.feature.group,org.eclipse.mylyn.pde_feature.feature.group,org.eclipse.mylyn.team_feature.feature.group,org.eclipse.mylyn.trac_feature.feature.group,org.eclipse.mylyn.versions.feature.group,org.eclipse.mylyn.wikitext_feature.feature.group,org.eclipse.mylyn_feature.feature.group
repoUrls=$repoUrls,http://update.atlassian.com/atlassian-eclipse-plugin/e3.7
features=$features,com.atlassian.connector.eclipse.jira.feature.group,com.atlassian.connector.eclipse.subclipse.feature.group,com.atlassian.connector.eclipse.feature.group

# regex tester
repoUrls=$repoUrls,http://regex-util.sourceforge.net/update/
features=$features,com.ess.regexutil.feature.group

# anyedit tools
repoUrls=$repoUrls,http://andrei.gmxhome.de/eclipse/
features=$features,AnyEditTools.feature.group,EclipseSkins.feature.group

# spring tools
#repoUrls=$repoUrls,http://dist.springsource.com/release/TOOLS/update/e3.6
repoUrls=$repoUrls,http://dist.springsource.com/release/TOOLS/update/e3.7
#features=$features,org.springframework.ide.eclipse.aop.feature.feature.group,org.springframework.ide.eclipse.autowire.feature.feature.group,org.springframework.ide.eclipse.batch.feature.feature.group,org.springframework.ide.eclipse.feature.feature.group,org.springframework.ide.eclipse.integration.feature.feature.group,org.springframework.ide.eclipse.mylyn.feature.feature.group,org.springframework.ide.eclipse.osgi.feature.feature.group,org.springframework.ide.eclipse.security.feature.feature.group,org.springframework.ide.eclipse.webflow.feature.feature.group
features=$features,org.springframework.ide.eclipse.aop.feature.feature.group,org.springframework.ide.eclipse.autowire.feature.feature.group,org.springframework.ide.eclipse.feature.feature.group,org.springframework.ide.eclipse.integration.feature.feature.group,org.springframework.ide.eclipse.mylyn.feature.feature.group,org.springframework.ide.eclipse.osgi.feature.feature.group,org.springframework.ide.eclipse.security.feature.feature.group,org.springframework.ide.eclipse.uaa.feature.feature.group,org.springframework.ide.eclipse.webflow.feature.feature.group

# mat
repoUrls=$repoUrls,http://download.eclipse.org/mat/1.0/update-site/
#features=$features,org.eclipse.mat.chart.feature.feature.group,org.eclipse.mat.feature.feature.group

# eclipse color theme
features=$features,com.github.eclipsecolortheme.feature.feature.group
repoUrls=$repoUrls,http://eclipse-color-theme.github.com/update/

# ShellEd
#repoUrls=$repoUrls,http://download.eclipse.org/technology/linuxtools/updates-nightly/,http://akurtakov.fedorapeople.org/shelled/updates/
#features=$features,org.eclipse.linuxtools.man,net.sourceforge.shelled.feature.group

destEclipse=$(pwd)/eclipse
echo $destEclipse
echo $features

/Applications/eclipse/eclipse \
   -nosplash \
   -application org.eclipse.equinox.p2.director \
   -repository $repoUrls \
   -installIU $features \
   -destination $destEclipse \
   -roaming \
   -p2.os macosx -p2.ws cocoa -p2.arch x86_64 \
   -profile epp.package.jee

# to get builds for the other platforms
   #-p2.os win32 -p2.ws win32 -p2.arch x86 \
   #-p2.os linux -p2.ws gtk -p2.arch x86_64 \
   #-p2.os macosx -p2.ws cocoa -p2.arch x86_64 \



   #!/bin/bash

INSTALL_DIR=$1

#wget http://download.eclipse.org/eclipse/updates/4.4-I-builds/
mkdir -p $INSTALL_DIR

wget http://download.eclipse.org/eclipse/downloads/drops4/S-4.4M6-201403061200/eclipse-SDK-4.4M6-linux-gtk-x86_64.tar.gz -O /tmp/foobar123.tar.gz
tar xfz /tmp/foobar123.tar.gz -C $INSTALL_DIR
mv $INSTALL_DIR/eclipse $INSTALL_DIR/238946
mv $INSTALL_DIR/238946/* $INSTALL_DIR/
rm -rf $INSTALL_DIR/238946

# declare an array variable
#declare -a arr=(org.eclipse.nebula.feature com.mousefeed.feature com.google.eclipse.mechanic org.eclipse.ecf.remoteservice.sdk.feature org.eclipse.wb.rcp.feature org.eclipse.wb.rcp.feature org.eclipse.e4.core.tools.feature org.eclipse.e4.tools.css.spy.feature org.eclipse.egit.mylyn org.eclipse.mylyn.git org.eclipse.mylyn.gerrit.feature org.eclipse.mylyn.bugzilla_feature org.eclipse.mylyn.github_feature org.eclipse.mylyn.ide_feature org.eclipse.mylyn.java_feature org.eclipse.mylyn.tasks.ide org.eclipse.mylyn.team_feature org.eclipse.mylyn.pde_feature)
FEATURES="org.eclipse.nebula.feature.feature.group,com.mousefeed.feature.feature.group,org.eclipse.egit.mylyn.feature.group,org.eclipse.mylyn.git.feature.group,org.eclipse.mylyn.ide_feature.feature.group,org.eclipse.mylyn.java_feature.feature.group,org.eclipse.mylyn.tasks.ide.feature.group,org.eclipse.mylyn.team_feature.feature.group"
REPOSITORIES="http://download.eclipse.org/eclipse/updates/4.4-I-builds/,http://download.eclipse.org/technology/nebula/snapshot/,http://download.sigasi.com/updates/mousefeed,http://download.eclipse.org/releases/luna,http://workspacemechanic.eclipselabs.org.codespot.com/git.update/mechanic/,http://download.eclipse.org/rt/ecf/latest/site.p2,http://download.eclipse.org/windowbuilder/WB/milestone/M2/4.4/,http://download.eclipse.org/mylyn/drops/3.9.1/v20130917-0100,http://download.eclipse.org/e4/updates/0.15/"

## now loop through the above array
#for i in ${arr[@]}
#do
#   echo $i # or do whatever with individual element of the array
#done

cd $INSTALL_DIR/
./eclipse \
    -noSplash \
    -application org.eclipse.equinox.p2.director \
    -repository $REPOSITORIES \
    -i $FEATURES \
    -roaming -profile SDKProfile \
    -profileProperties org.eclipse.update.install.features=true


/Applications/eclipse/eclipse \
   -nosplash \
   -application org.eclipse.equinox.p2.director \
   -repository $repoUrls \
   -installIU $features \
   -destination $destEclipse \
   -roaming \
   -p2.os macosx -p2.ws cocoa -p2.arch x86_64 \
   -profile epp.package.jee

# traditional style tabs
#sed -i 's/swt-simple: false;/swt-simple: true;/g' plugins/org.eclipse.ui.themes_*/css/e4_classic_winxp.css

#cd $INSTALL_DIR/dropins
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.http.api-2.2.2.jar

#wget http://mirror.dkd.de/apache//felix/org.apache.felix.http.whiteboard-2.2.2.jar
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.fileinstall-3.4.0.jar

#wget http://mirror.dkd.de/apache//felix/org.apache.felix.webconsole-4.2.2.jar
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.webconsole.plugins.ds-1.0.0.jar
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.webconsole.plugins.event-1.1.0.jar
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.webconsole.plugins.memoryusage-1.0.4.jar
#wget http://mirror.dkd.de/apache//felix/org.apache.felix.webconsole.plugins.obr-1.0.0.jar
