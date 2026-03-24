class CVStrings {
  final String profileTitle;
  final String profileDesc;
  final String experienceTitle;
  final String educationTitle;
  final String skillsTitle;
  final String languagesTitle;
  final String aboutTitle;
  final String volunteeringTitle;
  final String certificatesTitle;
  final String contactTitle;
  final String presentLabel;
  final String projectsTitle;
  final String techStackTitle;
  final List<ExperienceItem> experience;
  final List<EducationItem> education;
  final List<LanguageItem> languages;
  final List<SkillItem> programmingSkills;
  final List<String> interests;
  final List<VolunteerItem> volunteering;
  final List<String> certificates;
  final List<ProjectItem> projects;
  final List<TechCategory> techStack;
  final String quote;
  final String quoteAuthor;

  const CVStrings({
    required this.profileTitle,
    required this.profileDesc,
    required this.experienceTitle,
    required this.educationTitle,
    required this.skillsTitle,
    required this.languagesTitle,
    required this.aboutTitle,
    required this.volunteeringTitle,
    required this.certificatesTitle,
    required this.contactTitle,
    required this.presentLabel,
    required this.projectsTitle,
    required this.techStackTitle,
    required this.experience,
    required this.education,
    required this.languages,
    required this.programmingSkills,
    required this.interests,
    required this.volunteering,
    required this.certificates,
    required this.projects,
    required this.techStack,
    required this.quote,
    required this.quoteAuthor,
  });
}

class ExperienceItem {
  final String role;
  final String company;
  final String description;
  final String period;
  final String location;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.description,
    required this.period,
    required this.location,
  });
}

class EducationItem {
  final String school;
  final String degree;
  final String period;
  final String location;

  const EducationItem({
    required this.school,
    required this.degree,
    required this.period,
    required this.location,
  });
}

class LanguageItem {
  final String language;
  final String level;
  final String label;
  final int dots;

  const LanguageItem({
    required this.language,
    required this.level,
    required this.label,
    required this.dots,
  });
}

class SkillItem {
  final String name;
  final int level;

  const SkillItem({required this.name, required this.level});
}

class VolunteerItem {
  final String role;
  final String organization;

  const VolunteerItem({required this.role, required this.organization});
}

class ProjectItem {
  final String name;
  final String description;
  final List<String> tags;
  final String? githubUrl;
  final bool wip;

  const ProjectItem({
    required this.name,
    required this.description,
    required this.tags,
    this.githubUrl,
    this.wip = false,
  });
}

class TechCategory {
  final String label;
  final List<TechItem> items;

  const TechCategory({required this.label, required this.items});
}

class TechItem {
  final String name;
  final int colorHex;
  final String symbol;

  const TechItem({required this.name, required this.colorHex, required this.symbol});
}

// ─── SHARED DATA (language-independent) ──────────────────────────────────────

const sharedProjects = [
  ProjectItem(
    name: 'CryptoApp',
    description: 'Mobilná aplikácia pre sledovanie kryptomien — live ceny, grafy a prehľad portfólia.',
    tags: ['Flutter', 'Dart', 'API'],
    githubUrl: 'https://github.com/Artyfak/CryptoApp',
  ),
  ProjectItem(
    name: 'CV Web App',
    description: 'Interaktívny životopis postavený vo Flutter Web s podporou SK/EN prepínania a moderným dark UI.',
    tags: ['Flutter', 'Dart', 'Web'],
    githubUrl: 'https://github.com/Artyfak',
  ),
  ProjectItem(
    name: 'Projekt #3',
    description: 'Sem príde popis tvojho ďalšieho projektu. Doplň neskôr.',
    tags: ['Java'],
    wip: true,
  ),
];

const sharedProjectsEN = [
  ProjectItem(
    name: 'CryptoApp',
    description: 'Mobile app for tracking cryptocurrencies — live prices, charts and portfolio overview.',
    tags: ['Flutter', 'Dart', 'API'],
    githubUrl: 'https://github.com/Artyfak/CryptoApp',
  ),
  ProjectItem(
    name: 'CV Web App',
    description: 'Interactive resume built with Flutter Web featuring SK/EN language toggle and modern dark UI.',
    tags: ['Flutter', 'Dart', 'Web'],
    githubUrl: 'https://github.com/Artyfak',
  ),
  ProjectItem(
    name: 'Project #3',
    description: 'Description of your next project goes here. Fill in later.',
    tags: ['Java'],
    wip: true,
  ),
];

const sharedTechStack = [
  TechCategory(label: 'Languages', items: [
    TechItem(name: 'Java',       colorHex: 0xFFE76F51, symbol: 'Jv'),
    TechItem(name: 'Python',     colorHex: 0xFF3B82F6, symbol: 'Py'),
    TechItem(name: 'C#',         colorHex: 0xFF9B59B6, symbol: 'C#'),
    TechItem(name: 'Dart',       colorHex: 0xFF0175C2, symbol: 'Dt'),
    TechItem(name: 'SQL',        colorHex: 0xFF00758F, symbol: 'SQ'),
  ]),
  TechCategory(label: 'Frameworks & Platforms', items: [
    TechItem(name: 'Flutter',    colorHex: 0xFF54C5F8, symbol: 'Fl'),
    TechItem(name: 'Angular',    colorHex: 0xFFDD0031, symbol: 'Ng'),
  ]),
  TechCategory(label: 'Databases', items: [
    TechItem(name: 'MySQL',      colorHex: 0xFF00758F, symbol: 'My'),
    TechItem(name: 'PostgreSQL', colorHex: 0xFF336791, symbol: 'Pg'),
  ]),
  TechCategory(label: 'Tools', items: [
    TechItem(name: 'Docker',     colorHex: 0xFF2496ED, symbol: 'Dk'),
    TechItem(name: 'Git',        colorHex: 0xFFF05032, symbol: 'Gt'),
    TechItem(name: 'VS Code',    colorHex: 0xFF007ACC, symbol: 'VS'),
    TechItem(name: 'IntelliJ',   colorHex: 0xFFFF318C, symbol: 'IJ'),
  ]),
];

// ─── SLOVAK ───────────────────────────────────────────────────────────────────

const cvSK = CVStrings(
  profileTitle: 'Profil',
  profileDesc: 'Pracovitý • Rád opravuje veci • Neustále hľadá nové zručnosti a získava vedomosti',
  experienceTitle: 'Skúsenosti',
  educationTitle: 'Vzdelanie',
  skillsTitle: 'Programovacie zručnosti',
  languagesTitle: 'Jazyky',
  aboutTitle: 'O mne',
  volunteeringTitle: 'Dobrovoľníctvo',
  certificatesTitle: 'Certifikáty',
  contactTitle: 'Kontakt',
  presentLabel: 'súčasnosť',
  projectsTitle: 'Projekty',
  techStackTitle: 'Tech Stack',
  projects: sharedProjects,
  techStack: sharedTechStack,
  quote: '"Make it work, make it right, make it fast."',
  quoteAuthor: '— Kent Beck',
  experience: [
    ExperienceItem(
      role: 'Business Manager',
      company: 'Chicken Supreme Team',
      description: 'Manažér podniku a tímu pre požičovňu paddleboardov.',
      period: '2019 — 2022',
      location: 'Žilina, Slovensko',
    ),
    ExperienceItem(
      role: 'Audio Technik',
      company: 'Freelance',
      description: 'Inštalácia zariadení na koncerty, šofér, oprava zariadení.',
      period: '05/2021 — 12/2024',
      location: 'Žilina, Slovensko',
    ),
    ExperienceItem(
      role: 'Manažér predaja vstupeniek',
      company: 'MŠK Žilina',
      description: 'Zodpovedný za predaj a distribúciu vstupeniek na zápasy na štadióne MŠK Žilina.',
      period: '05/2023 — 12/2024',
      location: 'Žilina, Slovensko',
    ),
  ],
  education: [
    EducationItem(
      school: 'Stredná škola sv. Františka z Assisi',
      degree: 'Maturita',
      period: '2011 — 2019',
      location: 'Žilina, Slovensko',
    ),
    EducationItem(
      school: 'Univerzita Tomáša Baťu',
      degree: 'Fakulta aplikovanej informatiky',
      period: '2023 — súčasnosť',
      location: 'Zlín, Česká republika',
    ),
  ],
  languages: [
    LanguageItem(language: 'Slovenčina', level: 'C2', label: 'Rodný jazyk', dots: 6),
    LanguageItem(language: 'Angličtina', level: 'B2', label: 'Plynulo', dots: 4),
    LanguageItem(language: 'Nemčina', level: 'A1', label: 'Učím sa', dots: 1),
  ],
  programmingSkills: [
    SkillItem(name: 'Java', level: 3),
    SkillItem(name: 'Python', level: 2),
    SkillItem(name: 'C#', level: 2),
    SkillItem(name: 'Flutter / Dart', level: 1),
  ],
  interests: [
    'Saxofón', 'Sopránová flauta', 'Gitara',
    'Programovanie', 'Paddleboarding', 'Silový tréning',
    'Cyklistika', 'Šach', 'Dota',
  ],
  volunteering: [
    VolunteerItem(role: 'Pomocný vedúci tábora', organization: 'Saleziáni Don Bosca'),
    VolunteerItem(role: 'Muzikant', organization: 'Detský orchester'),
    VolunteerItem(role: 'Zbieranie vybavenia pre ľudí v núdzi', organization: 'Pomoc Ukrajine'),
  ],
  certificates: [
    'Vodičský preukaz sk. B',
  ],
);

// ─── ENGLISH ──────────────────────────────────────────────────────────────────

const cvEN = CVStrings(
  profileTitle: 'Profile',
  profileDesc: 'Hard working • Enjoys fixing things • Always looking for new skills and gaining knowledge',
  experienceTitle: 'Experience',
  educationTitle: 'Education',
  skillsTitle: 'Programming Skills',
  languagesTitle: 'Languages',
  aboutTitle: 'About Me',
  volunteeringTitle: 'Volunteering',
  certificatesTitle: 'Certificates',
  contactTitle: 'Contact',
  presentLabel: 'present',
  projectsTitle: 'Projects',
  techStackTitle: 'Tech Stack',
  projects: sharedProjectsEN,
  techStack: sharedTechStack,
  quote: '"Make it work, make it right, make it fast."',
  quoteAuthor: '— Kent Beck',
  experience: [
    ExperienceItem(
      role: 'Business Manager',
      company: 'Chicken Supreme Team',
      description: 'Business manager and team manager for a paddleboard rental service.',
      period: '2019 — 2022',
      location: 'Žilina, Slovakia',
    ),
    ExperienceItem(
      role: 'Audio Technician',
      company: 'Freelance',
      description: 'Setting up equipment for concerts, driver, equipment repair.',
      period: '05/2021 — 12/2024',
      location: 'Žilina, Slovakia',
    ),
    ExperienceItem(
      role: 'Ticketing Sales Manager',
      company: 'MŠK Žilina',
      description: 'Responsible for managing ticket sales and distribution for matches at MŠK Žilina stadium.',
      period: '05/2023 — 12/2024',
      location: 'Žilina, Slovakia',
    ),
  ],
  education: [
    EducationItem(
      school: 'St. Francis of Assisi Secondary School',
      degree: 'School-leaving Certificate (Maturita)',
      period: '2011 — 2019',
      location: 'Žilina, Slovakia',
    ),
    EducationItem(
      school: 'Tomas Bata University',
      degree: 'Faculty of Applied Informatics',
      period: '2023 — present',
      location: 'Zlín, Czech Republic',
    ),
  ],
  languages: [
    LanguageItem(language: 'Slovak', level: 'C2', label: 'Native', dots: 6),
    LanguageItem(language: 'English', level: 'B2', label: 'Fluent', dots: 4),
    LanguageItem(language: 'German', level: 'A1', label: 'Learning', dots: 1),
  ],
  programmingSkills: [
    SkillItem(name: 'Java', level: 3),
    SkillItem(name: 'Python', level: 2),
    SkillItem(name: 'C#', level: 2),
    SkillItem(name: 'Flutter / Dart', level: 1),
  ],
  interests: [
    'Saxophone', 'Soprano Recorder', 'Guitar',
    'Coding', 'Paddleboarding', 'Weightlifting',
    'Cycling', 'Chess', 'Dota',
  ],
  volunteering: [
    VolunteerItem(role: 'Assistant Camp Director', organization: 'Salesians of Don Bosco'),
    VolunteerItem(role: 'Musician', organization: 'Children\'s Orchestra'),
    VolunteerItem(role: 'Obtaining Equipment for People in Need', organization: 'Help Ukraine'),
  ],
  certificates: [
    'Driver\'s Licence — Category B',
  ],
);
