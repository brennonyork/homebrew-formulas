require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class TitanServer < Formula
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-server-0.4.4.zip"
  sha1 "549f14f372fb94bf567a34f7e1bcc650addfee8a"

  patch :DATA

  def install
    libexec.install %w[conf doc ext lib log rexhome]
    (libexec/"bin").install "bin/titan.sh" => "titan"
    (libexec/"bin").install "bin/rexster.sh" => "titan-rexster"
    (libexec/"bin").install "bin/rexster-console.sh" => "titan-rexster-console"
    bin.install_symlink libexec/"bin/titan"
    bin.install_symlink libexec/"bin/titan-rexster"
    bin.install_symlink libexec/"bin/titan-rexster-console"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test titan-server`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff --git a/bin/gremlin.sh b/bin/gremlin.sh
index 2436bfa..ff7fc3f 100755
--- a/bin/gremlin.sh
+++ b/bin/gremlin.sh
@@ -7,11 +7,17 @@ case `uname` in
     CP=$CP;$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ';')
     ;;
   *)
-    CP=`dirname $0`/../conf
-    CP=$CP:$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
-    CP=$CP:$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ':')
+    SOURCE="${BASH_SOURCE[0]}"
+    while [ -h "$SOURCE" ]; do
+      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+      SOURCE="$(readlink "$SOURCE")"
+      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+    done
+    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+    CP=$DIR/../conf
+    CP=$CP:$( echo $DIR/../lib/*.jar . | sed 's/ /:/g')
+    CP=$CP:$(find -L $DIR/../ext/ -name "*.jar" | tr '\n' ':')
 esac
-#echo $CP
 
 # Find Java
 if [ "$JAVA_HOME" = "" ] ; then
diff --git a/bin/rexster-console.sh b/bin/rexster-console.sh
index dabc213..145085c 100755
--- a/bin/rexster-console.sh
+++ b/bin/rexster-console.sh
@@ -1,7 +1,13 @@
 #!/bin/bash
 
 set_unix_paths() {
-    BIN="$(dirname $0)"
+    SOURCE="${BASH_SOURCE[0]}"
+    while [ -h "$SOURCE" ]; do
+        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+        SOURCE="$(readlink "$SOURCE")"
+        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+    done
+    BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     CP="$(echo $BIN/../conf $BIN/../lib/*.jar . | tr ' ' ':')"
     CP="$CP:$(find -L $BIN/../ext/ -name "*.jar" | tr '\n' ':')"
 }
diff --git a/bin/rexster.sh b/bin/rexster.sh
index 4d4ee47..484bc8f 100755
--- a/bin/rexster.sh
+++ b/bin/rexster.sh
@@ -1,6 +1,12 @@
 #!/bin/bash
 
-BIN="`dirname $0`"
+SOURCE="${BASH_SOURCE[0]}"
+while [ -h "$SOURCE" ]; do
+  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+  SOURCE="$(readlink "$SOURCE")"
+  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+done
+BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
 # Rexster doesn't allow GraphConfiguration implementations a clean way
 # to know the path to the rexster.xml config file.  This makes implementing
 # Titan's relative storage directory interpretation (relative to the file in
diff --git a/bin/titan.sh b/bin/titan.sh
index 0ea74c9..a78c48b 100755
--- a/bin/titan.sh
+++ b/bin/titan.sh
@@ -1,6 +1,12 @@
 #!/bin/bash
 
-BIN="`dirname $0`"
+SOURCE="${BASH_SOURCE[0]}"
+while [ -h "$SOURCE" ]; do
+  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+  SOURCE="$(readlink "$SOURCE")"
+  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+done
+BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
 REXSTER_CONFIG_TAG=cassandra-es
 : ${CASSANDRA_STARTUP_TIMEOUT_S:=60}
 : ${REXSTER_SHUTDOWN_TIMEOUT_S:=60}
diff --git a/bin/upgrade010to020.sh b/bin/upgrade010to020.sh
index 64265e4..6bc61df 100755
--- a/bin/upgrade010to020.sh
+++ b/bin/upgrade010to020.sh
@@ -6,10 +6,16 @@ case `uname` in
     CP=$CP:$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ';')
     ;;
   *)
-    CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
-    CP=$CP:$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ':')
+    SOURCE="${BASH_SOURCE[0]}"
+    while [ -h "$SOURCE" ]; do
+      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+      SOURCE="$(readlink "$SOURCE")"
+      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+    done
+    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+    CP=$( echo $DIR/../lib/*.jar . | sed 's/ /:/g')
+    CP=$CP:$(find -L $DIR/../ext/ -name "*.jar" | tr '\n' ':')
 esac
-#echo $CP
 
 # Find Java
 if [ "$JAVA_HOME" = "" ] ; then
@@ -24,4 +30,4 @@ if [ "$JAVA_OPTIONS" = "" ] ; then
 fi
 
 # Launch the application
-$JAVA $JAVA_OPTIONS -cp $CP:$CLASSPATH com.thinkaurelius.titan.upgrade.Upgrade010to020 $@
\ No newline at end of file
+$JAVA $JAVA_OPTIONS -cp $CP:$CLASSPATH com.thinkaurelius.titan.upgrade.Upgrade010to020 $@
