#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Genera recetasperfummua.sql con todos los extractos (sede 1 y sede 2)
import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# ============================================================
# EXTRACTOS SEDE 1 (239 items)
# ============================================================
extractos_s1 = [
    ("s1-208", "9 PM REBEL"),
    ("s1-213", "9 PM"),
    ("s1-002", "CORVUS"),
    ("s1-003", "KARPOS"),
    ("s1-001", "PEGASUS"),
    ("s1-004", "VEGA"),
    ("s1-006", "MAS"),
    ("s1-005", "AMBER OUD AQUA DUBAI"),
    ("s1-007", "AMBER OUD GOLD EDITION"),
    ("s1-008", "BLUE SEDUCTION"),
    ("2003",   "ANGEL KISS"),
    ("s1-009", "CLOUD PINK"),
    ("s1-010", "CLOUD"),
    ("s1-011", "SWEET LIKE CANDY"),
    ("s1-012", "THANK U NEXT"),
    ("s1-013", "CLUB DE NUIT INTENSE"),
    ("s1-233", "CLUB DE NUIT MALEKA"),
    ("s1-235", "ISLAND BREEZE"),
    ("s1-217", "ODYSSEY CHOCOLAT"),
    ("s1-205", "ODYSSEY MANDARIN SKY"),
    ("s1-211", "YUM YUM"),
    ("s1-014", "AZZARO POUR HOMME"),
    ("s1-015", "CRAZY FOR YOU"),
    ("s1-016", "BHARARA BLEU"),
    ("s1-210", "BHARARA CHOCOLATE"),
    ("s1-017", "BHARARA KING"),
    ("s1-238", "BHARARA NICHE"),
    ("s1-201", "BHARARA ROSE"),
    ("s1-018", "BLEECKER STREET"),
    ("s1-019", "FANTASY"),
    ("s1-020", "MIDNIGHT FANTASY"),
    ("s1-021", "BURBERRY HER"),
    ("s1-022", "BURBERRY"),
    ("s1-023", "AQVA MARINE"),
    ("s1-024", "BLV"),
    ("s1-025", "BVLGARI MAN IN BLACK"),
    ("s1-026", "OMNIA CORAL"),
    ("s1-027", "OMNIA CRYSTALLINE"),
    ("s1-028", "OMNIA PINK SAPPHIRE"),
    ("s1-029", "CK ONE"),
    ("s1-030", "CKIN2U"),
    ("s1-031", "212 HEROES FOREVER"),
    ("s1-032", "212 HEROES"),
    ("s1-033", "212 SEXY"),
    ("s1-034", "212 VIP BLACK RED"),
    ("s1-035", "212 VIP BLACK"),
    ("s1-036", "212 VIP PARTY FEVER"),
    ("s1-037", "212 VIP ROSE RED"),
    ("s1-038", "212 VIP ROSE"),
    ("s1-039", "212 VIP"),
    ("s1-040", "212 VIP"),
    ("s1-041", "212"),
    ("s1-042", "212"),
    ("s1-043", "BAD BOY COBALT"),
    ("s1-044", "BAD BOY"),
    ("s1-045", "CAROLINA HERRERA"),
    ("s1-046", "CH"),
    ("s1-047", "CH"),
    ("s1-048", "GOOD GIRL BLUSH"),
    ("s1-049", "GOOD GIRL"),
    ("s1-231", "LA BOMBA"),
    ("s1-050", "BOUQUET IDEALE"),
    ("s1-051", "ALLURE SPORT"),
    ("s1-052", "BLEU DE CHANEL"),
    ("s1-226", "CHANCE EAU TENDRE"),
    ("s1-053", "CHANCE"),
    ("s1-054", "COCO MADEMOISELLE"),
    ("s1-055", "N5"),
    ("s1-060", "DIOR HOMME INTENSE"),
    ("s1-056", "FAHRENHEIT"),
    ("s1-057", "JADORE"),
    ("s1-058", "MISS DIOR BOUQUET"),
    ("s1-059", "SAUVAGE ELIXIR"),
    ("s1-061", "SAUVAGE"),
    ("s1-062", "AVENTUS HER"),
    ("s1-063", "AVENTUS"),
    ("s1-220", "QUEEN OF SILK"),
    ("s1-064", "SILVER MOUNTAIN WATER"),
    ("s1-065", "CR7 ORIGINIS"),
    ("s1-066", "LEGACY"),
    ("s1-067", "BAD INTENSE"),
    ("s1-068", "DIESEL PLUS PLUS"),
    ("s1-069", "K"),
    ("s1-070", "LIGHT BLUE"),
    ("s1-230", "NITRO ELIXIR"),
    ("s1-234", "NITRO RED"),
    ("s1-071", "AGUA DE SOL"),
    ("s1-223", "MIAMI BLOSSOM"),
    ("s1-073", "SORBETTO ROSSO"),
    ("s1-074", "TAJ SUNSET"),
    ("s1-075", "DORSAY"),
    ("s1-076", "FACONNABLE"),
    ("s1-077", "BIANCO LATTE"),
    ("s1-078", "ARSENAL"),
    ("s1-079", "ACQUA DI GIO PROFONDO"),
    ("s1-080", "ACQUA DI GIO"),
    ("s1-081", "STRONGER WITH YOU"),
    ("s1-082", "GIVENCHY BLUE"),
    ("s1-083", "GIVENCHY"),
    ("s1-084", "GUCCI GUILTY POUR HOMME"),
    ("s1-085", "BOSS BOTTLED NIGHT"),
    ("s1-086", "BOSS BOTTLED UNLIMITED"),
    ("s1-087", "HUGO BOSS"),
    ("s1-088", "HUGO RED"),
    ("s1-239", "IL FEMME"),
    ("s1-089", "ISSEY MIYAKE"),
    ("s1-090", "ISSEY MIYAKE"),
    ("s1-091", "JEAN PASCAL"),
    ("s1-207", "DIVINE"),
    ("s1-092", "JEAN PAUL GAULTIER LE MALE"),
    ("s1-093", "LE BEAU"),
    ("s1-094", "LE MALE ELIXIR"),
    ("s1-095", "SCANDAL"),
    ("s1-096", "SCANDAL"),
    ("s1-097", "ULTRA MALE"),
    ("s1-098", "ALMAZ"),
    ("s1-204", "DAHAB"),
    ("s1-099", "FLOWER BY KENZO"),
    ("s1-100", "BFF"),
    ("s1-101", "LACOSTE BLANC"),
    ("s1-102", "LACOSTE ESSENTIAL"),
    ("s1-103", "LACOSTE NOIR"),
    ("s1-104", "LACOSTE RED"),
    ("s1-105", "LACOSTE WOMAN"),
    ("s1-106", "TOUCH OF PINK"),
    ("s1-107", "LA VIDA ES BELLA FLORAL"),
    ("s1-108", "LA VIDA ES BELLA"),
    ("s1-215", "AFEEF"),
    ("s1-110", "AL NOBLE AMEER"),
    ("s1-111", "AMETHYST"),
    ("s1-227", "ART OF UNIVERSE"),
    ("s1-112", "ASAD"),
    ("s1-237", "ECLAIRE"),
    ("s1-117", "EMEER"),
    ("s1-113", "HAYA"),
    ("s1-114", "HONOR Y GLORY"),
    ("s1-225", "KHAMRAH DUKHAN"),
    ("s1-115", "KHAMRAH"),
    ("s1-229", "MALLOW MADNESS"),
    ("s1-218", "MAYAR"),
    ("s1-109", "NOBLE BLUSH"),
    ("s1-116", "OUD FOR GLORY"),
    ("s1-118", "QAED AL FURSAN"),
    ("s1-119", "RAMZ SILVER"),
    ("s1-120", "SHAHEEN GOLD"),
    ("s1-121", "SUBLIME"),
    ("s1-232", "VAINILLA FREAK"),
    ("s1-206", "VICTORIA"),
    ("s1-122", "YARA CANDY"),
    ("s1-123", "YARA"),
    ("s1-124", "SANTAL 33"),
    ("s1-125", "SOLO"),
    ("s1-126", "LOLITA LEMPICKA"),
    ("s1-127", "SUMMER HAMMER"),
    ("s1-214", "SUN GRIA"),
    ("s1-209", "IMAGINATION"),
    ("s1-128", "L\u00b4IMMENSITE"),
    ("s1-221", "OMBRE NOMADE"),
    ("s1-129", "OUD MARACUJA"),
    ("s1-130", "BACCARAT ROUGE 540"),
    ("s1-212", "RED TOBACCO"),
    ("s1-131", "DAISY LOVE"),
    ("s1-132", "ARABIANS TONKA"),
    ("s1-133", "NEPAL AOUD"),
    ("s1-134", "STARRY NIGHT"),
    ("s1-135", "STARWALKER"),
    ("s1-136", "MOSCHINO FOREVER"),
    ("s1-137", "TOY 2 BUBBLE GUM"),
    ("s1-138", "TOY 2 PEARL"),
    ("s1-139", "TOY 2"),
    ("s1-140", "TOY BOY"),
    ("s1-141", "NAUTICA VOYAGE"),
    ("s1-142", "AMBER ROUGE"),
    ("s1-143", "VELVET GOLD"),
    ("s1-144", "OSCAR DE LA RENTA"),
    ("s1-145", "1 MILLION ELIXIR"),
    ("s1-146", "1 MILLION INTENSE"),
    ("s1-147", "1 MILLION LUCKY"),
    ("s1-148", "1 MILLION PRIVE"),
    ("s1-149", "1 MILLION ROYAL"),
    ("s1-150", "1 MILLION"),
    ("s1-151", "BLACK XS AFRODISIACA"),
    ("s1-152", "BLACK XS"),
    ("s1-153", "FAME"),
    ("s1-154", "INVICTUS INTENSE"),
    ("s1-155", "INVICTUS LEGEND"),
    ("s1-222", "INVICTUS VICTORY ABSOLU"),
    ("s1-156", "INVICTUS VICTORY ELIXIR"),
    ("s1-157", "INVICTUS VICTORY"),
    ("s1-158", "INVICTUS"),
    ("s1-159", "LADY MILLION GOLD"),
    ("s1-160", "LADY MILLION"),
    ("s1-161", "OLYMPEA"),
    ("s1-162", "PHANTOM INTENSE"),
    ("s1-163", "PURE XS"),
    ("s1-164", "PURE XS"),
    ("s1-236", "ALTHAIR"),
    ("s1-165", "DELINA"),
    ("s1-166", "KALAN"),
    ("s1-167", "LAYTON"),
    ("s1-168", "CAN CAN"),
    ("s1-169", "DAZZLE"),
    ("s1-170", "HEIRESS"),
    ("s1-171", "PARIS HILTON"),
    ("s1-172", "ROSE RUSH"),
    ("s1-173", "360 PURPLE"),
    ("s1-174", "360"),
    ("s1-175", "360"),
    ("s1-228", "PARADOXE"),
    ("s1-176", "POLO BLUE"),
    ("s1-177", "POLO RED"),
    ("s1-178", "RALPH"),
    ("s1-219", "SWEET TOOTH"),
    ("s1-179", "SELENA GOMEZ"),
    ("s1-180", "ELIXIR"),
    ("s1-181", "SOFIA"),
    ("s1-182", "LAPIDUS POUR HOMME"),
    ("s1-183", "ANGEL"),
    ("s1-184", "ANGEL"),
    ("s1-185", "TOMMY GIRL"),
    ("s1-186", "TOMMY"),
    ("s1-216", "DONNA BORN ROMA EXTRADOSE"),
    ("s1-224", "DONNA CLASICA"),
    ("s1-187", "UOMO BORN IN ROMA INTENSE"),
    ("s1-188", "BRIGHT CRYSTAL"),
    ("s1-189", "DYLAN PURPLE"),
    ("s1-190", "DYLAN TURQUOISE"),
    ("s1-203", "EROS ENERGY"),
    ("s1-191", "EROS"),
    ("s1-192", "BOMBSHELL"),
    ("s1-193", "COCONUT PASSION"),
    ("s1-194", "SWISS ARMY"),
    ("s1-195", "ERBA PURA"),
    ("s1-202", "NAXOS"),
    ("s1-196", "OHM"),
    ("s1-197", "SOLO"),
    ("s1-198", "BABYCAT"),
    ("s1-199", "BLACK OPIUM"),
    ("s1-200", "Y"),
]

assert len(extractos_s1) == 239, f"Se esperaban 239 extractos s1, se encontraron {len(extractos_s1)}"

# ============================================================
# EXTRACTOS SEDE 2 (351 items)
# ============================================================
extractos_s2 = [
    ("s2-291", "BERGAMOTTO DI CALABRIA"),
    ("s2-328", "9 PM"),
    ("s2-136", "CORVUS"),
    ("s2-278", "KARPOS"),
    ("s2-281", "OVERDOSE"),
    ("s2-332", "PEGASUS"),
    ("s2-247", "VEGA"),
    ("s2-310", "AMBER OUD AQUA DUBAI"),
    ("s2-317", "AMBER OUD DUBAI NIGHT"),
    ("s2-265", "AMBER OUD GOLD EDITION"),
    ("s2-264", "AMBER OUD TOBACCO"),
    ("s2-213", "LAVENTURE BLANCHE"),
    ("s2-289", "MADINAH"),
    ("s2-011", "BLUE SEDUCTION"),
    ("s2-348", "ANGEL KISS"),
    ("s2-195", "CLOUD PINK"),
    ("s2-176", "CLOUD"),
    ("s2-217", "MOD BLUSH"),
    ("s2-241", "SWEET LIKE CANDY"),
    ("s2-248", "THANK U NEXT"),
    ("s2-021", "CLUB DE NUIT INTENSE"),
    ("s2-987", "CLUB DE NUIT MALEKA"),
    ("s2-292", "CLUB DE NUIT SILLAGE"),
    ("s2-989", "ISLAND BREEZE"),
    ("s2-346", "ODYSSEY CHOCOLAT"),
    ("s2-341", "ODYSSEY MANDARIN SKY"),
    ("s2-336", "YUM YUM"),
    ("s2-165", "K VIDA FEM"),
    ("s2-324", "AZZARO POUR HOMME"),
    ("s2-175", "CRAZY FOR YOU"),
    ("s2-082", "BHARARA BLEU"),
    ("s2-307", "BHARARA KING"),
    ("s2-267", "BHARARA NICHE"),
    ("s2-308", "BLEECKER STREET"),
    ("s2-154", "FANTASY"),
    ("s2-153", "MIDNIGHT FANTASY"),
    ("s2-140", "BURBERRY HER"),
    ("s2-139", "BURBERRY"),
    ("s2-075", "AQVA MARINE"),
    ("s2-327", "BLV"),
    ("s2-323", "BVLGARI MAN IN BLACK"),
    ("s2-220", "OMNIA CORAL"),
    ("s2-221", "OMNIA CRYSTALLINE"),
    ("s2-180", "OMNIA PINK SAPPHIRE"),
    ("s2-183", "AMOR AMOR"),
    ("s2-271", "CK ONE"),
    ("s2-190", "CKIN2U"),
    ("s2-151", "ESCAPE"),
    ("s2-085", "ETERNITY"),
    ("s2-070", "212 HEROES FOREVER"),
    ("s2-251", "212 HEROES"),
    ("s2-252", "212 SEXY"),
    ("s2-103", "212 SEXY"),
    ("s2-129", "212 VIP BLACK EXTRA"),
    ("s2-067", "212 VIP BLACK RED"),
    ("s2-068", "212 VIP BLACK"),
    ("s2-069", "212 VIP PARTY FEVER"),
    ("s2-253", "212 VIP ROSE EXTRA"),
    ("s2-232", "212 VIP ROSE RED"),
    ("s2-255", "212 VIP ROSE"),
    ("s2-254", "212 VIP WILD PARTY"),
    ("s2-250", "212 VIP WINS"),
    ("s2-127", "212 VIP WINS"),
    ("s2-257", "212 VIP"),
    ("s2-128", "212 VIP"),
    ("s2-256", "212"),
    ("s2-130", "212"),
    ("s2-081", "BAD BOY COBALT"),
    ("s2-015", "BAD BOY"),
    ("s2-187", "CAROLINA HERRERA"),
    ("s2-020", "CAROLINA HERRERA"),
    ("s2-147", "CH BEAUTIES"),
    ("s2-145", "CH"),
    ("s2-017", "CH"),
    ("s2-080", "CHIC FOR MEN"),
    ("s2-158", "GOOD GIRL BLUSH"),
    ("s2-159", "GOOD GIRL"),
    ("s2-899", "LA BOMBA"),
    ("s2-231", "VERY GLAM"),
    ("s2-249", "VERY GOOD GIRL"),
    ("s2-270", "EAU DE CARTIER"),
    ("s2-188", "BOUQUET IDEALE"),
    ("s2-076", "ALLURE SPORT"),
    ("s2-012", "BLEU DE CHANEL"),
    ("s2-891", "CHANCE EAU TENDRE"),
    ("s2-146", "CHANCE"),
    ("s2-191", "COCO MADEMOISELLE"),
    ("s2-185", "N5"),
    ("s2-334", "DIOR HOMME INTENSE"),
    ("s2-086", "FAHRENHEIT"),
    ("s2-166", "JADORE"),
    ("s2-216", "MISS DIOR BOUQUET"),
    ("s2-062", "SAUVAGE ELIXIR"),
    ("s2-118", "SAUVAGE"),
    ("s2-133", "AVENTUS HER"),
    ("s2-005", "AVENTUS"),
    ("s2-143", "CARMINA"),
    ("s2-088", "GREEN IRISH TWEED"),
    ("s2-712", "QUEEN OF SILK"),
    ("s2-116", "SILVER MOUNTAIN WATER"),
    ("s2-016", "CR7 ORIGINIS"),
    ("s2-043", "LEGACY"),
    ("s2-078", "BAD INTENSE"),
    ("s2-022", "DIESEL PLUS PLUS"),
    ("s2-087", "FUEL FOR LIFE"),
    ("s2-096", "ONLY THE BRAVE"),
    ("s2-061", "SPIRIT OF THE BRAVE"),
    ("s2-197", "DEVOTION"),
    ("s2-023", "DOLCE Y GABBANA POUR HOMME"),
    ("s2-199", "DOLCE Y GABBANA"),
    ("s2-037", "K"),
    ("s2-172", "LIGHT BLUE"),
    ("s2-234", "PINEAPPLE"),
    ("s2-898", "NITRO ELIXIR"),
    ("s2-988", "NITRO RED"),
    ("s2-198", "DIAMANTES BLANCOS"),
    ("s2-003", "ADRENALINE"),
    ("s2-182", "AGUA DE SOL"),
    ("s2-141", "BORN IN PARADISE"),
    ("s2-189", "CHERRY IN THE AIR"),
    ("s2-200", "FIESTA CARIOCA"),
    ("s2-888", "MIAMI BLOSSOM"),
    ("s2-215", "MOON SPARKLE"),
    ("s2-239", "SORBETTO ROSSO"),
    ("s2-226", "TAJ SUNSET"),
    ("s2-083", "DORSAY"),
    ("s2-102", "WINNER SPORT"),
    ("s2-026", "FACONNABLE"),
    ("s2-260", "273"),
    ("s2-269", "BIANCO LATTE"),
    ("s2-002", "ARSENAL"),
    ("s2-074", "ACQUA DI GIO ABSOLU"),
    ("s2-073", "ACQUA DI GIO PROFONDO"),
    ("s2-111", "ACQUA DI GIO"),
    ("s2-119", "STRONGER WITH YOU"),
    ("s2-306", "GIVENCHY BLUE"),
    ("s2-027", "GIVENCHY"),
    ("s2-211", "INTERDIT"),
    ("s2-177", "ORGANZA"),
    ("s2-028", "GUCCI GUILTY POUR HOMME"),
    ("s2-205", "GUESS GIRL"),
    ("s2-014", "BOSS BOTTLED NIGHT"),
    ("s2-013", "BOSS BOTTLED UNLIMITED"),
    ("s2-007", "BOSS IN MOTION"),
    ("s2-009", "BOSS ORANGE"),
    ("s2-077", "BOSS THE SCENT ABSOLUTE"),
    ("s2-030", "HUGO BOSS"),
    ("s2-029", "HUGO RED"),
    ("s2-063", "THE SCENT PURE ACCORD"),
    ("s2-305", "XX"),
    ("s2-274", "IL EGO"),
    ("s2-296", "IL FEMME"),
    ("s2-295", "IL KAKUNO"),
    ("s2-298", "MUSK THERAPY"),
    ("s2-164", "ISSEY MIYAKE"),
    ("s2-032", "ISSEY MIYAKE"),
    ("s2-132", "JEAN PASCAL"),
    ("s2-339", "DIVINE"),
    ("s2-036", "JEAN PAUL GAULTIER LE MALE"),
    ("s2-207", "JEAN PAUL GAULTIER"),
    ("s2-038", "LE BEAU"),
    ("s2-093", "LE MALE ELIXIR"),
    ("s2-242", "SCANDAL"),
    ("s2-114", "SCANDAL"),
    ("s2-120", "ULTRA MALE"),
    ("s2-089", "HALLOWEEN"),
    ("s2-318", "ALMAZ"),
    ("s2-219", "MEOW"),
    ("s2-156", "FLOWER BY KENZO"),
    ("s2-287", "ROLLING IN LOVE"),
    ("s2-168", "BFF"),
    ("s2-044", "LACOSTE BLANC"),
    ("s2-094", "LACOSTE ESSENTIAL"),
    ("s2-210", "LACOSTE MAGNETIC"),
    ("s2-041", "LACOSTE NOIR"),
    ("s2-040", "LACOSTE RED"),
    ("s2-171", "LACOSTE WOMAN"),
    ("s2-214", "SPARKLING"),
    ("s2-243", "TOUCH OF PINK"),
    ("s2-169", "LA VIDA ES BELLA FLORAL"),
    ("s2-170", "LA VIDA ES BELLA"),
    ("s2-344", "AFEEF"),
    ("s2-322", "AL NOBLE AMEER"),
    ("s2-263", "AMEER AL OUDH INTENSE"),
    ("s2-262", "AMETHYST"),
    ("s2-895", "ART OF UNIVERSE"),
    ("s2-001", "ASAD"),
    ("s2-991", "ECLAIRE"),
    ("s2-335", "EMEER"),
    ("s2-161", "HAYA"),
    ("s2-319", "HER CONFESSION"),
    ("s2-272", "HONOR Y GLORY"),
    ("s2-890", "KHAMRAH DUKHAN"),
    ("s2-277", "KHAMRAH"),
    ("s2-897", "MALLOW MADNESS"),
    ("s2-337", "MAYAR CHERRY INTENSE"),
    ("s2-347", "MAYAR"),
    ("s2-330", "NOBLE BLUSH"),
    ("s2-283", "OUD FOR GLORY"),
    ("s2-284", "QAED AL FURSAN"),
    ("s2-285", "RAMZ SILVER"),
    ("s2-313", "SEHR"),
    ("s2-315", "SHAHEEN GOLD"),
    ("s2-288", "SUBLIME"),
    ("s2-338", "TERIAQ INTENSE"),
    ("s2-900", "VAINILLA FREAK"),
    ("s2-311", "YARA CANDY"),
    ("s2-246", "YARA"),
    ("s2-280", "MATCHA 26"),
    ("s2-301", "SANTAL 33"),
    ("s2-039", "LOEWE 7"),
    ("s2-059", "SOLO"),
    ("s2-173", "LOLITA LEMPICKA"),
    ("s2-321", "SUMMER HAMMER"),
    ("s2-343", "SUN GRIA"),
    ("s2-181", "ATTRAPE REVES"),
    ("s2-045", "L\u00b4IMMENSITE"),
    ("s2-051", "OMBRE NOMADE"),
    ("s2-299", "OUD MARACUJA"),
    ("s2-268", "BACCARAT ROUGE 540"),
    ("s2-293", "INSTANT CRUSH"),
    ("s2-275", "JARDIN EXCLUSIF"),
    ("s2-342", "RED TOBACCO"),
    ("s2-303", "SILVER BLUE"),
    ("s2-196", "DAISY LOVE"),
    ("s2-174", "MERCEDEZ BENZ IN RED"),
    ("s2-261", "ARABIANS TONKA"),
    ("s2-273", "INTENSE CAFE"),
    ("s2-333", "NEPAL AOUD"),
    ("s2-302", "STARRY NIGHT"),
    ("s2-025", "EXPLORER"),
    ("s2-046", "LEGEND RED"),
    ("s2-042", "LEGEND"),
    ("s2-117", "STARWALKER"),
    ("s2-245", "FUNNY"),
    ("s2-050", "MOSCHINO FOREVER"),
    ("s2-244", "TOY 2 BUBBLE GUM"),
    ("s2-304", "TOY 2 PEARL"),
    ("s2-228", "TOY 2"),
    ("s2-049", "TOY BOY"),
    ("s2-048", "NAUTICA VOYAGE"),
    ("s2-218", "LES MONSTRES DE NINA RICCI LUNA"),
    ("s2-107", "ARRURU"),
    ("s2-105", "COOL BOY"),
    ("s2-106", "DOLLY GIRL"),
    ("s2-104", "GALAXY"),
    ("s2-108", "MIMITOS"),
    ("s2-109", "PRETTY IN PINK"),
    ("s2-110", "SWEET CREAM"),
    ("s2-266", "AMBER ROUGE"),
    ("s2-290", "AZURE FANTASY"),
    ("s2-282", "OUD SAFFRON"),
    ("s2-223", "VELVET GOLD"),
    ("s2-052", "OSCAR DE LA RENTA"),
    ("s2-122", "1 MILLION ELIXIR"),
    ("s2-124", "1 MILLION INTENSE"),
    ("s2-125", "1 MILLION LUCKY"),
    ("s2-121", "1 MILLION PRIVE"),
    ("s2-123", "1 MILLION ROYAL"),
    ("s2-126", "1 MILLION"),
    ("s2-112", "BLACK XS AFRODISIACA"),
    ("s2-079", "BLACK XS BE LEGEND"),
    ("s2-008", "BLACK XS L`EXCES"),
    ("s2-184", "BLACK XS POTION"),
    ("s2-006", "BLACK XS POTION"),
    ("s2-010", "BLACK XS"),
    ("s2-155", "FAME"),
    ("s2-091", "INVICTUS INTENSE"),
    ("s2-031", "INVICTUS LEGEND"),
    ("s2-034", "INVICTUS VICTORY ELIXIR"),
    ("s2-033", "INVICTUS VICTORY"),
    ("s2-113", "INVICTUS"),
    ("s2-325", "LADY MILLION GOLD"),
    ("s2-212", "LADY MILLION LUCKY"),
    ("s2-209", "LADY MILLION"),
    ("s2-178", "OLYMPEA"),
    ("s2-329", "PHANTOM INTENSE"),
    ("s2-098", "PHANTOM LEGION"),
    ("s2-053", "PHANTOM"),
    ("s2-058", "PURE XS NIGHT"),
    ("s2-222", "PURE XS"),
    ("s2-057", "PURE XS"),
    ("s2-990", "ALTHAIR"),
    ("s2-326", "DELINA"),
    ("s2-276", "KALAN"),
    ("s2-279", "LAYTON"),
    ("s2-300", "PEGASUS"),
    ("s2-286", "SEDLEY"),
    ("s2-148", "CAN CAN"),
    ("s2-150", "DAZZLE"),
    ("s2-162", "HEIRESS"),
    ("s2-236", "PARIS HILTON"),
    ("s2-055", "PARIS HILTON"),
    ("s2-179", "PASSPORT IN PARIS"),
    ("s2-224", "ROSE RUSH"),
    ("s2-233", "360 CORAL"),
    ("s2-258", "360 PURPLE"),
    ("s2-072", "360 RED"),
    ("s2-259", "360"),
    ("s2-131", "360"),
    ("s2-896", "PARADOXE"),
    ("s2-100", "POLO BLUE"),
    ("s2-056", "POLO RED"),
    ("s2-060", "RALPH CLUB"),
    ("s2-235", "RALPH"),
    ("s2-090", "INSURRECTION"),
    ("s2-167", "KISS"),
    ("s2-312", "MARIA FARINA"),
    ("s2-694", "SWEET TOOTH"),
    ("s2-240", "SELENA GOMEZ"),
    ("s2-152", "ELIXIR"),
    ("s2-237", "ROCK"),
    ("s2-238", "SOFIA"),
    ("s2-320", "CHEIROSA 68"),
    ("s2-092", "LAPIDUS POUR HOMME"),
    ("s2-135", "ANGEL NOVA"),
    ("s2-134", "ANGEL"),
    ("s2-004", "ANGEL"),
    ("s2-297", "KIRKE"),
    ("s2-229", "TOMMY GIRL"),
    ("s2-099", "TOMMY"),
    ("s2-889", "DONNA BORN IN ROMA"),
    ("s2-345", "DONNA BORN ROMA EXTRADOSE"),
    ("s2-316", "UOMO BORN IN ROMA INTENSE"),
    ("s2-066", "VALENTINO UOMO"),
    ("s2-137", "BRIGHT CRYSTAL"),
    ("s2-331", "DYLAN PURPLE"),
    ("s2-149", "DYLAN TURQUOISE"),
    ("s2-101", "EAU FRAICHE"),
    ("s2-340", "EROS ENERGY"),
    ("s2-084", "EROS FLAME"),
    ("s2-024", "EROS"),
    ("s2-138", "BOMBSHELL"),
    ("s2-144", "COCONUT PASSION"),
    ("s2-208", "JUICED BERRY"),
    ("s2-230", "VAINILLA"),
    ("s2-115", "SWISS ARMY"),
    ("s2-294", "ERBA PURA"),
    ("s2-193", "CCORI ROSE"),
    ("s2-194", "CELOS"),
    ("s2-186", "CIELO"),
    ("s2-206", "GAIA"),
    ("s2-095", "OHM"),
    ("s2-225", "OSADIA"),
    ("s2-054", "OSADIA"),
    ("s2-097", "SOLO"),
    ("s2-227", "TEMPTATION"),
    ("s2-064", "TEMPTATION"),
    ("s2-314", "BABYCAT"),
    ("s2-142", "BLACK OPIUM"),
    ("s2-065", "Y"),
]

assert len(extractos_s2) == 351, f"Se esperaban 351 extractos s2, se encontraron {len(extractos_s2)}"

# ============================================================
# GENERACION DEL SQL
# ============================================================
total_extractos = len(extractos_s1) + len(extractos_s2)
total_prods     = total_extractos * 3
total_recipes   = total_prods * 3

lines = []
lines.append("-- ============================================================")
lines.append("-- RECETAS COMPLETAS: Perfumes terminados BOM (Bill of Materials)")
lines.append("-- Tenant: d46bec36-5259-4b5b-83c7-01f1e6ea5dcd (Perfum Mua)")
lines.append(f"-- Sede 1: {len(extractos_s1)} extractos  |  Sede 2: {len(extractos_s2)} extractos")
lines.append(f"-- Total: {total_extractos} extractos x 3 presentaciones = {total_prods} productos terminados")
lines.append(f"-- {total_recipes} registros de recetas (3 ingredientes x 3 tamanos)")
lines.append("-- Ejecutar: mysql -u root -p stockpro_db < recetasperfummua.sql")
lines.append("-- NOTA: Ejecutar primero este archivo, luego inventario_perfummua.sql")
lines.append("-- ============================================================")
lines.append("")
lines.append("USE stockpro_db;")
lines.append("")

# ============================================================
# 1. TABLA DE RECETAS
# ============================================================
lines.append("-- ============================================================")
lines.append("-- 1. TABLA DE RECETAS")
lines.append("-- ============================================================")
lines.append("CREATE TABLE IF NOT EXISTS product_recipes (")
lines.append("    id VARCHAR(36) PRIMARY KEY,")
lines.append("    tenant_id VARCHAR(36) NOT NULL,")
lines.append("    product_id VARCHAR(36) NOT NULL,")
lines.append("    ingredient_id VARCHAR(36) NOT NULL,")
lines.append("    quantity DECIMAL(10,3) NOT NULL,")
lines.append("    include_in_cost TINYINT(1) NOT NULL DEFAULT 1,")
lines.append("    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,")
lines.append("    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,")
lines.append("    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,")
lines.append("    FOREIGN KEY (ingredient_id) REFERENCES products(id) ON DELETE RESTRICT,")
lines.append("    INDEX idx_recipe_product (product_id),")
lines.append("    INDEX idx_recipe_tenant (tenant_id)")
lines.append(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;")
lines.append("")
lines.append("ALTER TABLE product_recipes ADD COLUMN IF NOT EXISTS include_in_cost TINYINT(1) NOT NULL DEFAULT 1;")
lines.append("")

# ============================================================
# 2. VARIABLES
# ============================================================
lines.append("-- ============================================================")
lines.append("-- 2. VARIABLES")
lines.append("-- ============================================================")
lines.append("SET @tid    = 'd46bec36-5259-4b5b-83c7-01f1e6ea5dcd' COLLATE utf8mb4_unicode_ci;")
lines.append("SET @env30  = 'prod-pm-2002' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 30ML  ($2,738)")
lines.append("SET @env100 = 'prod-pm-2004' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 100ML ($2,847)")
lines.append("SET @caj30  = 'prod-pm-2005' COLLATE utf8mb4_unicode_ci; -- CAJA 30-50ML         ($1,800)")
lines.append("SET @caj100 = 'prod-pm-2006' COLLATE utf8mb4_unicode_ci; -- CAJA 100ML           ($1,600)")
lines.append("SET @env50  = 'prod-pm-2007' COLLATE utf8mb4_unicode_ci; -- ENVASE LACOSTE 50ML  ($2,808)")
lines.append("")

# ============================================================
# 3. CATEGORIA PERFUMERIA
# ============================================================
lines.append("-- ============================================================")
lines.append("-- 3. CATEGORIA PERFUMERIA (si no existe)")
lines.append("-- ============================================================")
lines.append("INSERT IGNORE INTO categories (id, tenant_id, name, description) VALUES")
lines.append("('cat-pm-perfumeria', @tid, 'Perfumer\u00eda', 'Perfumes terminados: originales y r\u00e9plicas');")
lines.append("")

# ============================================================
# 4. LIMPIAR DATOS PREVIOS
# ============================================================
lines.append("-- ============================================================")
lines.append("-- 4. LIMPIAR DATOS PREVIOS (idempotente)")
lines.append("-- ============================================================")
lines.append("DELETE FROM product_recipes WHERE tenant_id = @tid AND product_id LIKE 'PERF-%';")
lines.append("DELETE FROM products WHERE tenant_id = @tid AND id LIKE 'PERF-s1-%';")
lines.append("DELETE FROM products WHERE tenant_id = @tid AND id LIKE 'PERF-s2-%';")
lines.append("")

# ============================================================
# 5. INSUMOS: CAJAS Y ENVASES
# ============================================================
lines.append("-- ============================================================")
lines.append("-- 5. INSUMOS: CAJAS Y ENVASES")
lines.append("-- ============================================================")
lines.append("INSERT IGNORE INTO categories (id, tenant_id, name, description) VALUES")
lines.append("('INSUMOS', @tid, 'Insumos', 'Insumos, envases y materiales');")
lines.append("")
lines.append("INSERT IGNORE INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
lines.append("('prod-pm-2006', @tid, 'CAJA 100 ML', 'CAJA 100 ML', 'INSUMOS', 'insumos', 'PM-2006', 0, 0, CURDATE(), 1600, 0, NULL, 'Caja perfume 100ML', 'sede-pm-1'),")
lines.append("('prod-pm-2005', @tid, 'CAJA 30-50 ML', 'CAJA 30-50 ML', 'INSUMOS', 'insumos', 'PM-2005', 0, 0, CURDATE(), 1800, 0, NULL, 'Caja perfume 30-50ML', 'sede-pm-1'),")
lines.append("('prod-pm-2004', @tid, 'ENVASE LACOSTE 100ML', 'ENVASE LACOSTE 100ML', 'INSUMOS', 'insumos', 'PM-2004', 0, 0, CURDATE(), 2847, 0, NULL, 'Envase vidrio 100ML', 'sede-pm-1'),")
lines.append("('prod-pm-2002', @tid, 'ENVASE-LACOSTE 30ML', 'ENVASE-LACOSTE 30ML', 'INSUMOS', 'insumos', 'PM-2002', 0, 0, CURDATE(), 2738, 0, NULL, 'Envase vidrio 30ML', 'sede-pm-1'),")
lines.append("('prod-pm-2007', @tid, 'ENVASE-LACOSTE 50 ML', 'ENVASE-LACOSTE 50 ML', 'INSUMOS', 'insumos', 'PM-2007', 0, 0, CURDATE(), 2808, 0, NULL, 'Envase vidrio 50ML', 'sede-pm-1');")
lines.append("")


def gen_products(extractos, sede_id, section_num_base):
    """Generate INSERT statements for 30ML, 50ML, 100ML products for a given sede."""
    result = []

    # ---- 30ML ----
    result.append("-- ============================================================")
    result.append(f"-- {section_num_base}. PRODUCTOS TERMINADOS 30ML - {sede_id.upper()}")
    result.append("--    13g extracto + envase 30ML + caja")
    result.append("--    Precio venta: $22,000")
    result.append("-- ============================================================")
    result.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
    rows = []
    for code, name in extractos:
        pid = f"PERF-{code}-030"
        sku = f"PM-PERF-{code.upper()}-030"
        ext_id = f"prod-pm-{code}"
        rows.append(
            f"('{pid}', @tid, '{name} 30ML', 'PERF-{name} 30ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 0, 22000, '30ML', 'Extracto: {ext_id}', '{sede_id}')"
        )
    result.append(",\n".join(rows) + ";")
    result.append("")

    # ---- 50ML ----
    result.append("-- ============================================================")
    result.append(f"-- {section_num_base+1}. PRODUCTOS TERMINADOS 50ML - {sede_id.upper()}")
    result.append("--    22g extracto + envase 50ML + caja")
    result.append("--    Precio venta: $38,000")
    result.append("-- ============================================================")
    result.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
    rows = []
    for code, name in extractos:
        pid = f"PERF-{code}-050"
        sku = f"PM-PERF-{code.upper()}-050"
        ext_id = f"prod-pm-{code}"
        rows.append(
            f"('{pid}', @tid, '{name} 50ML', 'PERF-{name} 50ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 0, 38000, '50ML', 'Extracto: {ext_id}', '{sede_id}')"
        )
    result.append(",\n".join(rows) + ";")
    result.append("")

    # ---- 100ML ----
    result.append("-- ============================================================")
    result.append(f"-- {section_num_base+2}. PRODUCTOS TERMINADOS 100ML - {sede_id.upper()}")
    result.append("--    43g extracto + envase 100ML + caja")
    result.append("--    Precio venta: $75,000")
    result.append("-- ============================================================")
    result.append("INSERT INTO products (id, tenant_id, name, articulo, category, product_type, sku, stock, reorder_point, entry_date, purchase_price, sale_price, presentation, notes, sede_id) VALUES")
    rows = []
    for code, name in extractos:
        pid = f"PERF-{code}-100"
        sku = f"PM-PERF-{code.upper()}-100"
        ext_id = f"prod-pm-{code}"
        rows.append(
            f"('{pid}', @tid, '{name} 100ML', 'PERF-{name} 100ML', 'cat-pm-perfumeria', 'perfumes', '{sku}', 0, 0, CURDATE(), 0, 75000, '100ML', 'Extracto: {ext_id}', '{sede_id}')"
        )
    result.append(",\n".join(rows) + ";")
    result.append("")

    return result


# ---- Productos Sede 1 ----
lines.extend(gen_products(extractos_s1, "sede-pm-1", 6))

# ---- Productos Sede 2 ----
lines.extend(gen_products(extractos_s2, "sede-pm-2", 9))


def gen_recipes(extractos, label):
    """Generate BOM recipe rows for a given extractos list."""
    result = []
    all_recipe_rows = []
    for code, name in extractos:
        ext_id = f"prod-pm-{code}"
        p30  = f"PERF-{code}-030"
        p50  = f"PERF-{code}-050"
        p100 = f"PERF-{code}-100"
        # 30ML
        all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  '{ext_id}', 13)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  @env30, 1)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p30}',  @caj30, 1)")
        # 50ML
        all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  '{ext_id}', 22)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  @env50, 1)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p50}',  @caj30, 1)")
        # 100ML
        all_recipe_rows.append(f"(UUID(), @tid, '{p100}', '{ext_id}', 43)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p100}', @env100, 1)")
        all_recipe_rows.append(f"(UUID(), @tid, '{p100}', @caj100, 1)")

    batch_size = 800
    for i in range(0, len(all_recipe_rows), batch_size):
        batch = all_recipe_rows[i:i+batch_size]
        start_ext = i // 9 + 1
        end_ext   = min((i + batch_size) // 9, len(extractos))
        result.append(f"-- Recetas {label} extractos {start_ext}-{end_ext}")
        result.append("INSERT INTO product_recipes (id, tenant_id, product_id, ingredient_id, quantity) VALUES")
        result.append(",\n".join(batch) + ";")
        result.append("")
    return result


# ---- RECETAS BOM ----
lines.append("-- ============================================================")
lines.append("-- 12. RECETAS BOM")
lines.append("--    30ML  = 13 extracto + 1 envase 30ML  + 1 caja 30-50ML")
lines.append("--    50ML  = 22 extracto + 1 envase 50ML  + 1 caja 30-50ML")
lines.append("--    100ML = 43 extracto + 1 envase 100ML + 1 caja 100ML")
lines.append("-- ============================================================")

lines.extend(gen_recipes(extractos_s1, "S1"))
lines.extend(gen_recipes(extractos_s2, "S2"))

# ---- UPDATE include_in_cost ----
lines.append("-- ============================================================")
lines.append("-- 13. MARCAR ENVASES COMO NO INCLUIDOS EN COSTO")
lines.append("-- Envases son solo control de inventario (no suman al costo)")
lines.append("-- Costo real: extracto + caja = $74,700 ~ $75,000 (100ML)")
lines.append("-- ============================================================")
lines.append("UPDATE product_recipes")
lines.append("SET include_in_cost = 0")
lines.append("WHERE tenant_id = @tid")
lines.append("  AND ingredient_id IN (@env30, @env50, @env100);")
lines.append("")

# ---- VERIFICACION ----
lines.append("-- ============================================================")
lines.append("-- 14. VERIFICACION")
lines.append("-- ============================================================")
lines.append("SELECT CONCAT('Productos terminados creados: ', COUNT(*)) AS resultado")
lines.append("FROM products WHERE tenant_id = @tid AND id LIKE 'PERF-%';")
lines.append("")
lines.append("SELECT CONCAT('Recetas creadas: ', COUNT(*)) AS resultado")
lines.append("FROM product_recipes WHERE tenant_id = @tid AND product_id LIKE 'PERF-%';")
lines.append("")
lines.append("SELECT")
lines.append("    p.name AS Perfume,")
lines.append("    p.presentation AS Presentacion,")
lines.append("    CONCAT('$', FORMAT(p.purchase_price, 0)) AS 'Costo BOM',")
lines.append("    CONCAT('$', FORMAT(p.sale_price, 0)) AS 'Precio Venta',")
lines.append("    CONCAT(ROUND((p.sale_price - p.purchase_price) / p.sale_price * 100, 1), '%') AS Margen,")
lines.append("    (SELECT FLOOR(MIN(CASE WHEN pr.quantity > 0 THEN ing.stock / pr.quantity ELSE 0 END))")
lines.append("     FROM product_recipes pr")
lines.append("     JOIN products ing ON ing.id = pr.ingredient_id")
lines.append("     WHERE pr.product_id = p.id) AS 'Stock Disponible BOM'")
lines.append("FROM products p")
lines.append("WHERE p.tenant_id = @tid AND p.id LIKE 'PERF-s1-001-%'")
lines.append("ORDER BY p.sale_price;")
lines.append("")
lines.append("SELECT 'Seed ejecutado correctamente. Los perfumes apareceran en el POS con su receta BOM.' AS RESULTADO;")

output = "\n".join(lines)
with open("recetasperfummua.sql", "w", encoding="utf-8") as f:
    f.write(output)

total_recipe_rows = (len(extractos_s1) + len(extractos_s2)) * 9
print(f"Generado: recetasperfummua.sql")
print(f"  Sede 1: {len(extractos_s1)} extractos")
print(f"  Sede 2: {len(extractos_s2)} extractos")
print(f"  Total extractos: {len(extractos_s1) + len(extractos_s2)}")
print(f"  Total productos terminados: {(len(extractos_s1) + len(extractos_s2)) * 3}")
print(f"  Total filas de receta: {total_recipe_rows}")
print(f"  Lineas SQL generadas: {len(lines)}")
print(f"  Precios venta: 30ML=$22,000 | 50ML=$38,000 | 100ML=$75,000 (purchase_price=0, el BOM calcula el costo real)")
