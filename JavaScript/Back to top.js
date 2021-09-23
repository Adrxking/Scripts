const btnScrollToTop = document.querySelector('#btnScrollToTop');
window.addEventListener('scroll', () => {
    if(window.pageYOffset > 100) {
        btnScrollToTop.classList.add("active");
    } else {
        btnScrollToTop.classList.remove("active");
    }
});

btnScrollToTop.addEventListener("click", function() {
    window.scrollTo({
        left: 0,
        top: 0,
        behavior: "smooth"
    });
});