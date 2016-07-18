val globalSettings = Seq(
  version := "1.0",
  scalaVersion := "2.10.5"
)

resolvers += "Spark Packages Repo" at "http://dl.bintray.com/spark-packages/maven"
resolvers += "Sonatype OSS Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"
resolvers += "Repo at github.com/ankurdave/maven-repo" at "https://github.com/ankurdave/maven-repo/raw/master"

lazy val streaming = (project in file("."))
                       .settings(name := "SparkStream")
                       .settings(globalSettings:_*)
                       .settings(libraryDependencies ++= streamingDeps)
val sparkVersion = "1.6.1"

lazy val streamingDeps = Seq(
  "org.apache.kafka" %% "kafka" % "0.8.2.1",
  "org.apache.spark" %% "spark-core" % sparkVersion % "provided",
  "com.databricks"      %% "spark-csv" % "1.4.0",
  "org.apache.spark"    %% "spark-mllib"           % sparkVersion % "provided",
  "org.apache.spark"    %% "spark-graphx"          % sparkVersion % "provided",
  "org.apache.spark"    %% "spark-sql"             % sparkVersion % "provided",
  "org.apache.spark"    %% "spark-streaming"       % sparkVersion % "provided",
  "org.apache.spark"    %% "spark-streaming-kafka" % sparkVersion,
  "org.postgresql" % "postgresql" % "9.4.1208.jre7"
)

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
   {
    case PathList("META-INF", xs @ _*) => MergeStrategy.discard
    case x => MergeStrategy.first
   }
}