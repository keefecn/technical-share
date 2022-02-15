| 序号 | 修改时间  | 修改内容 | 修改人 | 审稿人 |
| ---- | --------- | -------- | ------ | ------ |
| 1    | 2006-2007 | 创建     | Keefe | Keefe |
<br>
---



<br>
---
# 简介

Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform), it is free software available under the [MIT License](http://www.opensource.org/licenses/mit-license.html).


**数据类型：**
* xmlChar  替代char,使用UTF-8编码的一字节字符串。如果你的数据使用其它编码，它必须被转换到UTF-8才能使用libxml的函数。
* XmlDoc  包含由解析文档建立的树结构，xmlDocPtr是指向这个结构的指针。
* xmlNodePtr and xmlNode 包含单一结点的结构
* xmlNodePtr是指向这个结构的指针，它被用于遍历文档树。



​       优点：1.   安装、使用比较简单，容易入门；2.   支持的编码格式较多，能很好的解决中文问题(使用一个很简单的编码转换函数)；3.   支持Xpath解析（这点对于任意定位xml文档中的节点还是很有用的哦）；4.支持Well-formed 和valid验证，具体而言支持DTD验证，Schema验证功能正在完善中(目前多数解析器都还不完全支持shema验证功能)；5.   支持目前通用的Dom、Sax方式解析等等。

​       不足：1.  指针太多，使用不当时就会出现错误，在Linux系统中表现为常见的段错误，同样管理不当易造成内存泄漏；2.个人认为内面有些函数的功能设计的不是很好（比如获取Xpath函数，它不获取节点属性，这样子有些情况会定位不准）。

​       在学习libxml2中，最好的学习手册就是由官方开发者提供的开发手册就是libxml2-devel-2.6.19，rpm –q –d libxml2获得文档路径，就是它了。



## 关于xml

开始研究 LibXML2 库之前，让我们先来巩固一下 XML 的相关基础。XML 是一种基于文本的格式，它可用来创建能够通过各种语言和平台访问的结构化数据。它包括一系列类似 HTML 的标记，并以树型结构来对这些标记进行排列。

例如，可参见[清单 1](http://www-128.ibm.com/developerworks/cn/aix/library/au-libxml2.html?ca=drs-#listing1#listing1) 中介绍的简单文档。这是[配置文件](http://www-128.ibm.com/developerworks/cn/aix/library/au-libxml2.html?ca=drs-#configfile#configfile)部分中研究的配置文件示例的简化版本。为了更清楚地显示 XML 的一般概念，所以对其进行了简化。


 清单1.一个简单的XML文件

```xml
<?xml version="1.0" encoding="utf-8"?>
<files>
  <owner>root</owner>
  <action>delete</action>
  <age units="days">10</age>
</files>
```

[清单 1](http://www-128.ibm.com/developerworks/cn/aix/library/au-libxml2.html?ca=drs-#listing1#listing1) 中的第一行是 XML 声明，它告诉负责处理 XML 的应用程序，即解析器，将要处理的 XML 的版本。大部分的文件使用版本 1.0 编写，但也有少量的版本 1.1 的文件。它还定义了所使用的编码。大部分文件使用 UTF-8，但是，XML 设计用来集成各种语言中的数据，包括那些不使用英语字母的语言。

接下来出现的是元素。一个元素以*开始标记* 开始（如 <files>），并以*结束标记* 结束（如 </files>），其中使用斜线 (/) 来区别于开始标记。

元素是 Node 的一种类型。XML 文档对象模型 (DOM) 定义了几种不同的 Nodes 类型，包括 Elements（如 files 或者 age）、Attributes（如 units）和 Text（如 root 或者 10）。元素可以具有子节点。例如，age 元素有一个子元素，即文本节点 10。而 files 元素有七个子元素。其中三个很明显。它们分别是三个子元素：owner、action 和 age。其他四个分别是元素前后的空白文本符号。

XML 解析器可以利用这种父子结构来遍历文档，甚至修改文档的结构或内容。LibXML2 是这样的解析器中的其中一种，并且文中的示例应用程序正是使用这种结构来实现该目的。对于各种不同的环境，有许多不同的解析器和库。LibXML2 是用于 UNIX 环境的解析器和库中最好的一种，并且经过扩展，它提供了对几种脚本语言的支持，如 Perl 和 Python。



# 示例

## 1 tree
```c++
/***
 * compile: gcc -I/usr/include/libxml2/ -lxml2 tree1.c
 * usage: create a xml tree
 *
***/
#include <stdio.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
int main(int argc, char **argv)
{
	xmlDocPtr doc = NULL;       /* document pointer */
	xmlNodePtr root_node = NULL, node = NULL, node1 = NULL; /* node pointers */

	//Creates a new document, a node and set it as a root node
	doc = xmlNewDoc(BAD_CAST "1.0");
	root_node = xmlNewNode(NULL, BAD_CAST "root");
	xmlDocSetRootElement(doc, root_node);

	//creates a new node, which is "attached" as child node of root_node node.
	xmlNewChild(root_node, NULL, BAD_CAST "node1",BAD_CAST "content of node1");

	// xmlNewProp() creates attributes, which is "attached" to an node.
	node=xmlNewChild(root_node, NULL, BAD_CAST "node3", BAD_CAST"node has attributes");
	xmlNewProp(node, BAD_CAST "attribute", BAD_CAST "yes");
//Here goes another way to create nodes.
	node = xmlNewNode(NULL, BAD_CAST "node4");
	node1 = xmlNewText(BAD_CAST"other way to create content");
	xmlAddChild(node, node1);
	xmlAddChild(root_node, node);
//Dumping document to stdio or file
	xmlSaveFormatFileEnc(argc > 1 ? argv[1] : "-", doc, "UTF-8", 1);
/*free the document */
	xmlFreeDoc(doc);
	xmlCleanupParser();
	xmlMemoryDump();	//debug memory for regression tests

	return(0);
}
```

生成的xml:
```shell
[denny@localhost xml]$ gcc -I/usr/include/libxml2/ -lxml2 tree1.c
[denny@localhost xml]$ ./a.out
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <node1>content of node1</node1>

  <node3 attribute="yes">node has attributes</node3>
  <node4>other way to create content</node4>
</root>
```


**执行序列：**
1. 声明指针：文档指针(xmlDocPtr)，结点指针(xmlNodePtr)；
2. 生成文档doc：xmlNewDoc
3. 生成根结点root_node： xmlNewDocNode ，xmlNewNode
4. 文档与根结点捆绑： xmlDocSetRootElement
5. 结点操作
    1)创建子结点：xmlNewChild或xmlNewNode

    2)设置结点属性：xmlNewProp

    3)设置结点值：xmlNewText，xmlNewChild， xmlAddChild

6. 释放内存：xmlFreeDoc，xmlMemoryDump
7. lib的载入退出:  LIBXML_TEST_VERSION , xmlCleanupParser

## 2 parse

对于应用程序来说，读取 XML 文件的第一步是加载该数据并将其解析为一个 `Document` 对象。在此基础上，可以对 DOM 树进行遍历以获取特定的节点。
```c++
/***
* compile: gcc -I/usr/include/libxml2/ -lxml2 tree1.c
 * usage: tree2 filename_or_URL
 *
***/
#include <stdio.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

#ifdef LIBXML_TREE_ENABLED

static void
print_element_names(xmlNode * a_node)
{
    xmlNode *cur_node = NULL;
    for (cur_node = a_node; cur_node; cur_node = cur_node->next) {
        if (cur_node->type == XML_ELEMENT_NODE) {
            printf("node type: Element, name: %s\n", cur_node->name);
        }
        print_element_names(cur_node->children);
    }
}

/**
 * Simple example to parse a file called "file.xml",
 * walk down the DOM, and print the name of the
 * xml elements nodes.
 */
int
main(int argc, char **argv)
{
    xmlDoc *doc = NULL;
    xmlNode *root_element = NULL;

    if (argc != 2)
        return(1);

    //LIBXML_TEST_VERSION

    /*parse the file and get the DOM */
    doc = xmlReadFile(argv[1], NULL, 0);

    if (doc == NULL) {
        printf("error: could not parse file %s\n", argv[1]);
    }

    /*Get the root element node */
    root_element = xmlDocGetRootElement(doc);
    print_element_names(root_element);
    /*free the document */
    xmlFreeDoc(doc);
    //xmlCleanupParser();

    return 0;
}
#else
int main(void) {
    fprintf(stderr, "Tree support not compiled in\n");
    exit(1);
}
#endif

```


**执行序列：**

1. 声明指针：文档指针(xmlDocPtr)，结点指针(xmlNodePtr)；
2. 得到文档doc:  xmlReadFile
3. 得到根结点root_node：xmlDocGetRootElement
4. 结点操作：
    1)获得到结点值：xmlNodeGetContent(对应于xmlFree)
    2)遍历：
    - 指向下一个结点：xmlNodePtr ->children
    - 结点值：xmlNodePtr->name,
    - 结点内遍历：xmlNodePtr->next

5. 释放内存：xmlFreeDoc，xmlFree



## 3 reader & writer

在大型的xml文件中，使用专用的xml reader and xml writer, 读和写是分开的，这样可提高效率。

(writer )使用不同的API来写xml文件：(下面4个函数接口使用了writer的四种途径)
```c++
void testXmlwriterFilename(const char *uri);
void testXmlwriterMemory(const char *file);
void testXmlwriterDoc(const char *file);
void testXmlwriterTree(const char *file);
```



## 4 xpath & I/O



## 5 API Menu

### 5.1 加载文档

5.1.1 **文件加载(文件I/O)**

```c++
// parse an XML file from the filesystem or the network.
xmlDocPtr	xmlReadFile(const char * filename,
					 const char * encoding,
					 int options)

// parse an XML document from I/O functions and source and build a tree
xmlDocPtr	xmlReadIO(xmlInputReadCallback ioread,
					 xmlInputCloseCallback ioclose,
					 void * ioctx,
					 const char * URL,
					 const char * encoding,
					 int options)
// parse an XML file and build a tree. Automatic support for ZLIB/Compress compressed document is provided by default if found at compile-time. In the case the document is not Well Formed, a tree is built anyway
xmlDocPtr	xmlRecoverFile(const char * filename)
```

5.1.2 **DOM(内存占用)**

```c++
// parse an XML in-memory document and build a tree.
xmlDocPtr	xmlReadMemory(const char * buffer,
					 int size,
					 const char * URL,
					 const char * encoding,
					 int options)
// parse an XML in-memory document and build a tree. In the case the document is not Well Formed, a tree is built anyway
xmlDocPtr	xmlRecoverDoc(xmlChar * cur)

// parse an XML in-memory block and build a tree. In the case the document is not Well Formed, a tree is built anyway
xmlDocPtr	xmlRecoverMemory(const char * buffer,
					 int size)
```



5.1.3 **from parse**

```c++
// Creates a new XML document
xmlDocPtr	xmlNewDoc		(const xmlChar * version)
//
xmlNodePtr	xmlNewDocNode		(xmlDocPtr doc,
					 xmlNsPtr ns,
					 const xmlChar * name,
					 const xmlChar * content)
// parse an XML file and build a tree. Automatic support for ZLIB/Compress compressed document is provided by default if found at compile-time.
xmlDocPtr	xmlParseFile		(const char * filename)
```

### 5.2 释放，保存文档内容
```c++
// Dump the current DOM tree into memory using the character encoding specified by the caller. Note it is up to the caller of this function to free the allocated memory with xmlFree().
void	xmlDocDumpMemoryEnc(xmlDocPtr out_doc,
					 xmlChar ** doc_txt_ptr,
					 int * doc_txt_len,
					 const char * txt_encoding)
// Dump an XML document to a file. Will use compression if compiled in and enabled. If @filename is "-" the stdout file is used.
int	xmlSaveFile		(const char * filename,
					 xmlDocPtr cur)
// mp an XML document, converting it to the given encoding
int	xmlSaveFileEn	(const char * filename,
					 xmlDocPtr cur,
					 const char * encoding)
// Dump an XML document to an I/O buffer. Warning ! This call xmlOutputBufferClose() on buf which is not available after this call.
int	xmlSaveFileTo	(xmlOutputBufferPtr buf,
					 xmlDocPtr cur,
					 const char * encoding)
//
int	xmlSaveFormatFile		(const char * filename,
					 xmlDocPtr cur,
					 int format)
// Dump an XML document to a file or an URL.
int	xmlSaveFormatFileEnc		(const char * filename,
					 xmlDocPtr cur,
					 const char * encoding,
					 int format)
int	xmlSaveFormatFileTo		(xmlOutputBufferPtr buf,
					 xmlDocPtr cur,
					 const char * encoding,
					 int format)

```

### 5.3 根结点
```c++
// Get the root element of the document (doc->children is a list containing possibly comments, PIs, etc ...).
xmlNodePtr	xmlDocGetRootElement	(xmlDocPtr doc)
// Set the root element of the document (doc->children is a list containing possibly comments, PIs, etc ...).
xmlNodePtr	xmlDocSetRootElement	(xmlDocPtr doc, xmlNodePtr root)

```

### 5.4 结点创建释放操作
```c++
// Search the last child of a node.
xmlNodePtr	xmlGetLastChild		(xmlNodePtr parent)
// Build a structure based Path for the given node
xmlChar *	xmlGetNodePath		(xmlNodePtr node)
//
xmlNodePtr	xmlNewChild		(xmlNodePtr parent,
					 xmlNsPtr ns,
					 const xmlChar * name,
					 const xmlChar * content)
// Creation of a new node element. @ns is optional (NULL).
xmlNodePtr	xmlNewNode		(xmlNsPtr ns,
					 const xmlChar * name)
//Set (or reset) the name of a node.
void	xmlNodeSetName			(xmlNodePtr cur,
					 const xmlChar * name)
//Unlink a node from it's current context, the node is not freed
void	xmlUnlinkNode			(xmlNodePtr cur)
//Creation of a new child element, added at the end of @parent children list. @ns and @content parameters are optional (NULL). If @ns is NULL, the newly created element inherits the namespace of @parent. If @content is non NULL, a child list containing the TEXTs and ENTITY_REFs node will be created. NOTE: @content is supposed to be a piece of XML CDATA, so it allows entity references. XML special chars must be escaped first by using xmlEncodeEntitiesReentrant(), or xmlNewTextChild() should be used.
parent:	the parent node
ns:	a namespace if any
name:	the name of the child
content:	the XML content of the child if any.
Returns:	a pointer to the new node object
xmlNodePtr	xmlNewChild		(xmlNodePtr parent,
					 xmlNsPtr ns,
					 const xmlChar * name,
					 const xmlChar * content)

//Unlink the old node from its current context, prune the new one at the same place. If @cur was already inserted in a document it is first unlinked from its existing context
xmlNodePtr	xmlReplaceNode		(xmlNodePtr old,
					 xmlNodePtr cur)
                                [xmlNodePtr](file:///D:\STUDY\libxml2-devel-2.6.19\html\libxml-tree.html#xmlNodePtr) cur)

```

### 5.5 结点属性操作
```c++
//Create a new property carried by a node.
xmlAttrPtr	xmlNewProp		(xmlNodePtr node,
					 const xmlChar * name,
					 const xmlChar * value)
//Unlink and free one attribute, all the content is freed too Note this doesn't work for namespace definition attributes
int	xmlRemoveProp			(xmlAttrPtr cur)
//Set (or reset) an attribute carried by a node.
xmlAttrPtr	xmlSetProp		(xmlNodePtr node,
					 const xmlChar * name,
					 const xmlChar * value)

// Search and get the value of an attribute associated to a node This does the entity substitution. This function looks in DTD attribute declaration for #FIXED or default declaration values unless DTD use has been turned off. NOTE: this function acts independently of namespaces associated to the attribute. Use xmlGetNsProp() or xmlGetNoNsProp() for namespace aware processing.
xmlChar *	xmlGetProp		(xmlNodePtr node,
					 const xmlChar * name)
// Search and get the value of an attribute associated to a node This does the entity substitution. This function looks in DTD attribute declaration for #FIXED or default declaration values unless DTD use has been turned off. NOTE: this function acts independently of namespaces associated to the attribute. Use xmlGetNsProp() or xmlGetNoNsProp() for namespace aware processing.
node:	the node
name:	the attribute name
Returns:	the attribute value or NULL if not found. It's up to the caller to free the memory with xmlFree().
```

### 5.6 结点内容操作
```c++
//Read the value of a node, this can be either the text carried directly by this node if it's a TEXT node or the aggregate string of the values carried by this node child's (TEXT and ENTITY_REF). Entity references are substituted.
cur:	the node being read
Returns:	a new #xmlChar * or NULL if no content is available. It's up to the caller to free the memory with xmlFree().
xmlChar *	xmlNodeGetContent	(xmlNodePtr cur)

```

### 5.7 内存
```c++
// Free up all the structures used by a document, tree included
void	xmlFreeDoc			(xmlDocPtr cur)
// Free a node, this is a recursive behaviour, all the children are freed too. This doesn't unlink the child from the list, use xmlUnlinkNode() first.
void	xmlFreeNode			(xmlNodePtr cur)
// Free one attribute, all the content is freed too
void	xmlFreeProp			(xmlAttrPtr cur)
```



## 6 xml encapsulation(c++)



## 中文支持

LibXML2自身已经支持了中文编码.只是他的所有api处理的数据都是UTF-8类型的，所以只要在读入和写入数据时进行相应转换即可！代码1是使用linux下C API进行编码转换；代码2因为libxml2已融合了iconv，使用了libxml2的函数来进行编码转换.

1)  iconv
```c++
/*
compile:  gcc -I/usr/include/libxml2/ -lxml2 iconv.c
input:
    test.xml
<?xml version="1.0" encoding="gb2312"?>
<parent>测试</parent>
output:
    测试
*/

#include <libxml/xmlmemory.h>
#include <libxml/parser.h>
#include <arpa/inet.h>
#include <iconv.h>

char * Convert( char *encFrom, char *encTo, const char * in)
{
	static char bufin[1024], bufout[1024], *sin, *sout;
	int mode, lenin, lenout, ret, nline;
	iconv_t c_pt;

	if ((c_pt = iconv_open(encTo, encFrom)) == (iconv_t)-1)
	{
		printf("iconv_open false: %s ==> %s\n", encFrom, encTo);
		return NULL;
	}
	iconv(c_pt, NULL, NULL, NULL, NULL);

	lenin  = strlen(in) + 1;
	lenout = 1024;
	sin    = (char *)in;
	sout   = bufout;
	ret = iconv(c_pt, &sin, (size_t *)&lenin, &sout, (size_t *)&lenout);

	if (ret == -1)
	{
		return NULL;
	}
	iconv_close(c_pt);
	return bufout;
}

int main(void)
{
        xmlDocPtr doc = NULL;
        xmlNodePtr cur = NULL;
        doc = xmlParseFile("test.xml");
        cur = xmlDocGetRootElement(doc);
        printf("%s\n",  (char *)xmlNodeGetContent(cur));
        //printf("%s\n", Convert("utf-8", "gb2312", (char *)xmlNodeGetContent(cur)));
}
```



2)  xmlFindCharEncodingHandler

使用数据类型：xmlCharEncodingHandlerPtr
```c++
/***
 * compile: gcc -I/usr/include/libxml2/ -lxml2 convert.c
 * usage:  convert utf-8 string or null
 * input: ./convert 测试
 * output:
[wuqifu@localhost test]$ ./convert 测试
ISO-8859-1:虏芒脢脭
<?xml version="1.0" encoding="ISO-8859-1"?>
<root>测试</root>
***/
#include <libxml/encoding.h>
/**
 * function name: ConvertInput
 * input:
    @in: string in a given encoding
    @encoding: the encoding used
* description: Converts @in into UTF-8 for processing with libxml2 APIs
* return:  returns the converted UTF-8 string, or NULL in case of error.
**/
unsigned char* ConvertInput(const char *in, const char *encoding)
{
    unsigned char *out;
    int ret;
    int size;
    int out_size;
    int temp;
    xmlCharEncodingHandlerPtr handler;

    if (in == 0)
        return 0;

    handler = xmlFindCharEncodingHandler(encoding);

    if (!handler) {
        printf("ConvertInput: no encoding handler found for '%s'\n",
               encoding ? encoding : "");
        return 0;
    }

    size = (int) strlen(in) + 1;
    out_size = size * 2 - 1;
    out = (unsigned char *) xmlMalloc((size_t) out_size);

    if (out != 0) {
        temp = size - 1;
        ret = handler->input(out, &out_size, (const unsigned char *) in, &temp);
        if ((ret < 0) || (temp - size + 1)) {
            if (ret < 0) {
                printf("ConvertInput: conversion wasn't successful.\n");
            } else {
                printf
                    ("ConvertInput: conversion wasn't successful. converted: %i octets.\n",
                     temp);
            }

            xmlFree(out);
            out = 0;
        } else {
            out = (unsigned char *) xmlRealloc(out, out_size + 1);
            out[out_size] = 0;  /*null terminating out */
        }
    } else {
        printf("ConvertInput: no mem\n");
    }

    return out;
}

int	main(int argc, char **argv)
{
	unsigned char *content, *out;
	xmlDocPtr doc;
	xmlNodePtr rootnode;
	char *encoding = "ISO-8859-1";	 //utf-8, ISO-8859-1
	if (argc <= 1) {
		printf("Usage: %s content\n", argv[0]);
		return(0);
	}
	content = argv[1];

	out = ConvertInput(content, encoding);
	printf( "%s:%s\n", encoding, out  );
	doc = xmlNewDoc ("1.0");
	rootnode = xmlNewDocNode(doc, NULL, (const xmlChar*)"root", out);
	xmlDocSetRootElement(doc, rootnode);
	xmlSaveFormatFileEnc("-", doc, encoding, 1);
	return (1);
}
```



## 参考资料

[1].  官方网站：http://xmlsoft.org/

[2].  [使用LibXML2 处理配置文件](http://www.ibm.com/developerworks/cn/aix/library/au-libxml2.html) http://www.ibm.com/developerworks/cn/aix/library/au-libxml2.html

[3].  解决libxml2不支持中文的问题

http://blog.csdn.net/force_eagle/archive/2005/03/03/309644.aspx



