/**
 * treeview.js
 *
 * Provides a very simple UL based treeview implementation.
 * usage:
 *   ...
 *   <UL id="myTreeView">
 *     <LI>Title 1
 *       <UL>
 *         <LI>Title 1.1
 *         <LI>Title 1.2
 *       </UL></LI>
 *     <LI>Title 2</LI>
 *   </UL>
 *   <SCRIPT language='JavaScript' id='Constructor'>
 *     treeview_initialize("myTreeView", "images/treeview_expand.gif", "images/treeview_collapse.gif", "images/treeview_nop.gif")
 *   </SCRIPT>
 *   ...
 */

function treeview_onClick(treeviewId, i, expandImage, collapseImage)
{
  var treeview, items, button_a, button_img, children
  
  treeview = document.getElementById(treeviewId)
  items = treeview.getElementsByTagName('LI')
  button_a = items[i].firstChild
  button_img = button_a.firstChild
  children = items[i].getElementsByTagName('UL')[0]

  if (children.style.display == "none")
  {
    children.style.display = "block"
    button_img.src = collapseImage
  }
  else
  {
    children.style.display = "none"
    button_img.src = expandImage
  }
}

function treeview_getLevel(rootLu, li)
{
  var ul = li.parentNode
  if (ul == rootLu)
    return 1
  else
    return treeview_getLevel(rootLu, ul.parentNode) + 1
}

function treeview_initialize(treeviewId, expandImage, collapseImage, nopImage)
{
  var treeview, items, button_a, button_img, name

  treeview = document.getElementById(treeviewId) // get element from the html document based on its id (as defined in the html document)
  treeview.className = "treeview" //set new class name
  items = treeview.getElementsByTagName('LI') // get each section in the treeview

  for (var i=0; i < items.length; ++i) // for each section
  {
    items[i].className = "treeview_item" + treeview_getLevel(treeview, items[i]) //set new class name : LI.treeview_item1, LI.treeview_item_2, etc
    button_a = document.createElement('A') // create html element <a></a> (link)
    button_img = document.createElement('IMG') // create html element <img></img> (image)
    if (items[i].firstChild) // if this is the first child in the tree
      items[i].insertBefore(button_a, items[i].firstChild) // insert the link before if
    else
      items[i].appendChild(button_a) // otherwise insert after
    button_a.appendChild(button_img) // append the image to the link
    button_img.src = nopImage
    button_img.border = 0
    if (items[i].getElementsByTagName('UL')[0])
    {
      button_a.href = "javascript:treeview_onClick(\"" + treeviewId + "\", " + i + ", \"" + expandImage + "\", \"" + collapseImage + "\")"
      treeview_onClick(treeviewId, i, expandImage, collapseImage)
    }
    
    items[i].style.marginLeft = 16
    button_a.className = "treeview_button"
    button_a.style.marginLeft = -16
    button_a.style.marginRight = 4
  }
}

function treeview_initialize(treeviewId, expandImage, collapseImage, nopImage)
{
  var treeview, items, button_a, button_img, name

  treeview = document.getElementById(treeviewId) // get element from the html document based on its id (as defined in the html document)
  treeview.className = "treeview" //set new class name
  items = treeview.getElementsByTagName('LI') // get each section in the treeview

  for (var i=0; i < items.length; ++i) // for each section
  {
    items[i].className = "treeview_item" + treeview_getLevel(treeview, items[i]) //set new class name : LI.treeview_item1, LI.treeview_item_2, etc
    button_a = document.createElement('A') // create html element <a></a> (link)
    button_img = document.createElement('IMG') // create html element <img></img> (image)
    if (items[i].firstChild) // if this is the first child in the tree
      items[i].insertBefore(button_a, items[i].firstChild) // insert the link before if
    else
      items[i].appendChild(button_a) // otherwise insert after
    button_a.appendChild(button_img) // append the image to the link
    button_img.src = nopImage
    button_img.border = 0
	
    if (items[i].getElementsByTagName('UL')[0] && items[i].getElementsByTagName('A')[0])
    {
      button_a.href = "javascript:treeview_onClick(\"" + treeviewId + "\", " + i + ", \"" + expandImage + "\", \"" + collapseImage + "\")"
      title_link = items[i].getElementsByTagName('A')
	  title_link[1].href = "javascript:treeview_onClick(\"" + treeviewId + "\", " + i + ", \"" + expandImage + "\", \"" + collapseImage + "\")"
	  treeview_onClick(treeviewId, i, expandImage, collapseImage)
	  title_link[1].className = "treeview_button"
    }
    
    items[i].style.marginLeft = 16
    button_a.className = "treeview_button"
    button_a.style.marginLeft = -16
    button_a.style.marginRight = 4
  }
}



