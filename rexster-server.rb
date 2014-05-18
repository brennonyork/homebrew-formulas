require "formula"

class RexsterServer < Formula
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-server-2.5.0.zip"
  sha1 "1248ba9f892b62e8c24aee8642bc1fb9fc4e2413"

  patch :DATA

  def install
    libexec.install %w[config data doc ext lib]
    (libexec/"bin").install "bin/rexster.sh" => "rexster"
    (libexec/"bin").install "bin/rexster-service.sh" => "rexster-service"
    bin.install_symlink libexec/"bin/rexster"
    bin.install_symlink libexec/"bin/rexster-service"
  end

  test do
    system "#{bin}/rexster", "-h"
  end
end

__END__
diff --git a/bin/rexster.sh b/bin/rexster.sh
index 06f31a2..001e431 100755
--- a/bin/rexster.sh
+++ b/bin/rexster.sh
@@ -1,11 +1,22 @@
 #!/bin/bash
 
-CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
-CP=$CP:$(find -L `dirname $0`/../ext/ -name "*.jar" | tr '\n' ':')
-
-REXSTER_EXT=../ext
-
-PUBLIC=`dirname $0`/../public/
+# From: http://stackoverflow.com/a/246128
+#   - To resolve finding the directory after symlinks
+SOURCE="${BASH_SOURCE[0]}"
+# resolve $SOURCE until the file is no longer a symlink
+while [ -h "$SOURCE" ]; do
+  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+  SOURCE="$(readlink "$SOURCE")"
+  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+done
+DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+
+CP=$( echo $DIR/../lib/*.jar . | sed 's/ /:/g')
+CP=$CP:$(find -L $DIR/../ext/ -name "*.jar" | tr '\n' ':')
+
+REXSTER_EXT=$DIR/../ex
+
+PUBLIC=$DIR/../public/
 EXTRA=
 
 if [ $1 = "-s" ] ; then
