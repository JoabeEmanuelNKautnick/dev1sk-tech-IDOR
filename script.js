// Dev1sk TECH - Minimal JavaScript (No infinite loops!)

// Update cart count on page load
document.addEventListener('DOMContentLoaded', function() {
    updateCartCount();
});

// Update cart count from server
function updateCartCount() {
    const cartCountEl = document.getElementById('cartCount');
    if (!cartCountEl) return;
    
    fetch('get_cart_count.php')
        .then(response => response.json())
        .then(data => {
            if (data.count !== undefined) {
                cartCountEl.textContent = data.count;
            }
        })
        .catch(() => {
            // Silently fail
        });
}
