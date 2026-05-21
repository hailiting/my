initI18n();

const navToggle = document.getElementById('navToggle');
const navLinks = document.getElementById('navLinks');
const nav = document.getElementById('nav');

navToggle?.addEventListener('click', () => {
  navLinks.classList.toggle('open');
});

navLinks?.querySelectorAll('a').forEach((link) => {
  link.addEventListener('click', () => navLinks.classList.remove('open'));
});

window.addEventListener('scroll', () => {
  nav?.classList.toggle('scrolled', window.scrollY > 40);
});

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.01, rootMargin: '0px' }
);

/* 词云 Canvas 不参与淡入（避免手机端 opacity:0）；其余区块保留滚动入场 */
document.querySelectorAll('.ai-highlight, .advantage-card, .timeline-item, .project-card').forEach((el) => {
  /* .ai-about-panel 不参与淡入，保证 AI 模块始终可见 */
  el.style.opacity = '0';
  el.style.transform = 'translateY(20px)';
  el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
  observer.observe(el);
});
