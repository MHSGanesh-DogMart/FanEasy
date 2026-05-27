import '../domain/models/fan_page.dart';
import '../domain/models/host_city.dart';
import '../domain/models/league.dart';
import '../domain/models/match_fixture.dart';
import '../domain/models/sport_filter.dart';

/// Seed data for the Cities tab. Replace these constants with repository
/// fetches once the backend lands.

const List<SportFilter> kMockSports = <SportFilter>[
  SportFilter(
    id: 'soccer',
    label: 'Soccer',
    imageUrl:
        'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=200',
  ),
  SportFilter(
    id: 'baseball',
    label: 'Baseball',
    imageUrl:
        'https://images.unsplash.com/photo-1508344928928-7165b67de128?w=200',
  ),
  SportFilter(
    id: 'football',
    label: 'Football',
    imageUrl:
        'https://images.unsplash.com/photo-1566577739112-5180d4bf9390?w=200',
  ),
  SportFilter(
    id: 'basketball',
    label: 'BasketBall',
    imageUrl:
        'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=200',
  ),
  SportFilter(
    id: 'mma',
    label: 'MMA',
    imageUrl:
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=200',
  ),
];

const List<League> kMockLeagues = <League>[
  League(id: 'uefa', label: 'UEFA'),
  League(id: 'mls', label: 'MLS'),
  League(id: 'ligue1', label: 'League 1'),
  League(id: 'bundesliga', label: 'Bundesliga'),
  League(id: 'laliga', label: 'La Liga'),
];

const List<HostCity> kMockHostCities = <HostCity>[
  HostCity(
    name: 'Miami',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1535498730771-e735b998cd64?w=900',
    fansVisiting: '3.4K',
    fanPages: 32,
    matches: 6,
  ),
  HostCity(
    name: 'New York',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=900',
    fansVisiting: '5.1K',
    fanPages: 48,
    matches: 8,
  ),
  HostCity(
    name: 'Los Angeles',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=900',
    fansVisiting: '4.2K',
    fanPages: 41,
    matches: 7,
  ),
  HostCity(
    name: 'Atlanta',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1575917649705-5b59aaa12e6b?w=900',
    fansVisiting: '2.8K',
    fanPages: 24,
    matches: 5,
  ),
  HostCity(
    name: 'Dallas',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1545194445-dddb8f4487c6?w=900',
    fansVisiting: '3.0K',
    fanPages: 28,
    matches: 5,
  ),
  HostCity(
    name: 'Seattle',
    flag: '🇺🇸',
    coverUrl:
        'https://images.unsplash.com/photo-1438401171849-74ac270044ee?w=900',
    fansVisiting: '2.1K',
    fanPages: 19,
    matches: 4,
  ),
];

const List<FanPage> kMockFanPages = <FanPage>[
  FanPage(
    name: 'Germany Fans Page',
    subtitle: 'Global Germany Supporters.',
    coverUrl:
        'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?w=900',
    fansLabel: '54K fans',
    verified: true,
  ),
  FanPage(
    name: 'Brazil Samba Crew',
    subtitle: 'Verde-amarela worldwide.',
    coverUrl:
        'https://images.unsplash.com/photo-1518126437826-cc1cab2098f4?w=900',
    fansLabel: '72K fans',
    verified: true,
  ),
  FanPage(
    name: 'Argentina Albiceleste',
    subtitle: 'Vamos Argentina!',
    coverUrl:
        'https://images.unsplash.com/photo-1521731978332-9e9e714bdd20?w=900',
    fansLabel: '61K fans',
  ),
];

const List<MatchFixture> kMockMatches = <MatchFixture>[
  MatchFixture(
    competition: 'UEFA',
    homeTeam: 'FCB',
    awayTeam: 'PSG',
    homeLogoUrl:
        'https://upload.wikimedia.org/wikipedia/en/4/47/FC_Barcelona_%28crest%29.svg',
    awayLogoUrl:
        'https://upload.wikimedia.org/wikipedia/en/a/a7/Paris_Saint-Germain_F.C..svg',
    dateLabel: 'Sat, Jun 15, 2026 • 1:30 AM IST',
    venue: 'Camp Nou, Barcelona',
    accent: 0xFF6B0F1A,
  ),
  MatchFixture(
    competition: 'UEFA',
    homeTeam: 'PSG',
    awayTeam: 'BAY',
    homeLogoUrl:
        'https://upload.wikimedia.org/wikipedia/en/a/a7/Paris_Saint-Germain_F.C..svg',
    awayLogoUrl:
        'https://upload.wikimedia.org/wikipedia/en/1/1b/FC_Bayern_M%C3%BCnchen_logo_%282017%29.svg',
    dateLabel: 'Tue, Jun 18, 2026 • 12:30 AM IST',
    venue: 'Parc des Princes, Paris',
    accent: 0xFF0E2A6B,
  ),
];
