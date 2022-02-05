# stonarini-archetype
Template/Tutorial to create a custom archetype for Maven. 
Checks all the basic boxes: 
 - [X] Configure directory structure
 - [X] JaCoCo and JUnit  
 - [X] jar manifest

## The Basics
The first thing to know it's the basic structure and files we will need.  
From the [official documentation](https://maven.apache.org/guides/mini/guide-creating-archetypes.html):
```
archetype/
|-- pom.xml
`-- src/
    `-- main/
        `-- resources/
            |-- META-INF/
            |   `-- maven/
            |       `--archetype-metadata.xml
            `-- archetype-resources/
                |-- pom.xml
                `-- src/
                    |-- main/
                    |   `-- java/
                    |       `-- App.java
                    `-- test/
                        `-- java/
                            `-- AppTest.java
```
Let's brake it down:  

## archetype pom.xml
We start with the root folder *archetype*; In here we have to create a basic maven structure with a *pom.xml* and a *src/* folder with a *main/* subfolder.  
Now, instead of having a *java/* folder like a normal proyect, we have to create a folder called *resources/*. Our directory structure should look like this:
```
archetype/
|-- pom.xml
`-- src/main/resources/
```
In the *pom.xml* we just need to specify basic information. You can copy [my example](pom.xml) or the one from the [documentation](https://maven.apache.org/guides/mini/guide-creating-archetypes.html). Remember to change the project's *groupId* and *artifactId* to match your own.

## archetype-metadata.xml
Now in this *resources/* directory we need to create two more directories, *META-INF* and *maven* so our directory structure should look like this:
```
archetype/
|-- pom.xml
`-- src/main/resources/META-INF/maven/archetype-metadata.xml
```
And an xml file called *archetype-metadata.xml* that contains the information about what directory structure we want the archetype to automatically create.  
```xml
<archetype-descriptor xmlns="https://maven.apache.org/plugins/maven-archetype-plugin/archetype-descriptor/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://maven.apache.org/plugins/maven-archetype-plugin/archetype-descriptor/1.1.0 https://maven.apache.org/xsd/archetype-descriptor-1.1.0.xsd" name="stonarini-archetype">
    <fileSets>
        <fileSet filtered="true" packaged="true">
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.java</include>
            </includes>
        </fileSet>
        <fileSet filtered="true" packaged="true">
            <directory>src/test/java</directory>
            <includes>
                <include>**/*.java</include>
            </includes>
        </fileSet>
    </fileSets>
</archetype-descriptor>
<!-- archetype-metadata.xml -->
```
In this file we need to change the *name* attribute so that is the same as the *attributeId* in our *pom.xml*. Then, in the *fileSets* tag we need to specify the "raw" directory structure. In my case, I specified a simple maven structure with main and test. The ```packaged``` attribute is needed if you want the directories of your *groupId* to be created:
```yaml
groupId: edu.poniperro
```
```toml
packaged="false"
src/
|-- main/java/
`-- test/java/
```
```toml
packaged="true"
src/
|-- main/java/edu/poniperro
`-- test/java/edu/poniperro
```
While the ```filtered``` attribute is needed if you want to access the project's parameters inside a file, pay attention to the *${package}*:
```java
// filtered="false" (default)
package ${package};

public class App {
    public static void main(String[] args) {
        System.out.println("filtered=false");
    }
}
```
```java
// filtered="true"
package edu.poniperro;

public class App {
    public static void main(String[] args) {
        System.out.println("filtered=true");
    }
}
```
Last but not least, the *includes* tag. In this tag we can specify specific files we want to copy every time we use the archetype. I used a generic syntax to copy every java file present.