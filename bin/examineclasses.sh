#!/bin/bash
# Set the JAR name
# Loop through the classes (everything ending in .class)
for class in $(find . -name '*Repository.class' -print); do
    # Replace /'s with .'s
    class=${class//\//.};
    echo "${class//.class/}";
    # javap
    javap -classpath "$jar" "${class//.class/}";
done
