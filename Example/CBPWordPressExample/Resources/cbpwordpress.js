function loadingMore()
{
    var elements = document.getElementsByClassName('more-link');
    
    elements[0].innerHTML = 'Loading...';
}

function scrollIntoView(postId) {
    var e = document.getElementById('more-' + postId);
    if (!!e && e.scrollIntoView) {
        e.scrollIntoView();
    }
}

function changeFontSize(newSize)
{
    document.getElementById("singlentry").style.fontSize = newSize + "px";
}