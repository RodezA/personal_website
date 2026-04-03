// Active nav link highlighting via IntersectionObserver
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.site-nav a[href^="#"]');

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        navLinks.forEach((link) => {
          link.classList.toggle(
            'active',
            link.getAttribute('href') === '#' + entry.target.id
          );
        });
      }
    });
  },
  { threshold: 0.4 }
);

sections.forEach((section) => observer.observe(section));

// Mobile nav toggle
const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.site-nav');

toggle.addEventListener('click', () => {
  const isOpen = nav.classList.toggle('nav-open');
  toggle.setAttribute('aria-expanded', isOpen);
});

// Close mobile nav when an anchor link is clicked
navLinks.forEach((link) => {
  link.addEventListener('click', () => {
    nav.classList.remove('nav-open');
    toggle.setAttribute('aria-expanded', 'false');
  });
});
