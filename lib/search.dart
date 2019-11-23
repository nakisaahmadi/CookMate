import 'dart:convert';

import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
        primarySwatch: Colors.red,
    ),
    home: new MyHomePage(title: 'NAVBAR SHOULD BE HERE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  //final items = List<String>.generate(50, (i) => ingredients[i].name);
  //List<String> ingredientList = List<String>();
  //final duplicateItems = List<String>.generate(10000, (i) => "Tomato $i");
  List<String>duplicateItems = new List<String>();
  var items = List<String>();
  List<String> wordsToSend = List<String>();
  BackendRequest br = new BackendRequest();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  ingredientList() async{

    List<String> ingredientList = List<String>();


//  String json = "[{\"id\":1,\"name\":\"5 spice powder\"},{\"id\":2,\"name\":\"acorn squash\"},{\"id\":3,\"name\":\"adobo sauce\"},{\"id\":4,\"name\":\"agave nectar\"},{\"id\":5,\"name\":\"ahi tuna\"},{\"id\":6,\"name\":\"alfredo pasta sauce\"},{\"id\":7,\"name\":\"almond extract\"},{\"id\":8,\"name\":\"almond flour\"},{\"id\":9,\"name\":\"almond milk\"},{\"id\":10,\"name\":\"almonds\"},{\"id\":11,\"name\":\"amaretto\"},{\"id\":12,\"name\":\"ancho chiles\"},{\"id\":13,\"name\":\"anchovies\"},{\"id\":14,\"name\":\"andouille sausage\"},{\"id\":15,\"name\":\"angel food cake mix\"},{\"id\":16,\"name\":\"angel hair pasta\"},{\"id\":17,\"name\":\"angostura bitters\"},{\"id\":18,\"name\":\"apple\"},{\"id\":19,\"name\":\"apple butter spread\"},{\"id\":20,\"name\":\"apple cider\"},{\"id\":21,\"name\":\"apple juice\"},{\"id\":22,\"name\":\"apple pie spice\"},{\"id\":23,\"name\":\"apricot preserves\"},{\"id\":24,\"name\":\"apricots\"},{\"id\":25,\"name\":\"arborio rice\"},{\"id\":26,\"name\":\"arrowroot powder\"},{\"id\":27,\"name\":\"artichoke heart quarters\"},{\"id\":28,\"name\":\"artichokes\"},{\"id\":29,\"name\":\"arugula\"},{\"id\":30,\"name\":\"asafoetida\"},{\"id\":31,\"name\":\"asafoetida powder\"},{\"id\":32,\"name\":\"asiago cheese\"},{\"id\":33,\"name\":\"asian pear\"},{\"id\":34,\"name\":\"asparagus spears\"},{\"id\":35,\"name\":\"avocado\"},{\"id\":36,\"name\":\"avocado oil\"},{\"id\":37,\"name\":\"baby bell peppers\"},{\"id\":38,\"name\":\"baby bok choy\"},{\"id\":39,\"name\":\"baby carrots\"},{\"id\":40,\"name\":\"baby corn\"},{\"id\":41,\"name\":\"baby spinach leaves\"},{\"id\":42,\"name\":\"baby-back ribs\"},{\"id\":43,\"name\":\"bacon\"},{\"id\":44,\"name\":\"bacon fat\"},{\"id\":45,\"name\":\"baguette\"},{\"id\":46,\"name\":\"baking bar\"},{\"id\":47,\"name\":\"baking powder\"},{\"id\":48,\"name\":\"baking soda\"},{\"id\":49,\"name\":\"balsamic glaze\"},{\"id\":50,\"name\":\"balsamic vinegar\"},{\"id\":51,\"name\":\"bamboo shoots\"},{\"id\":52,\"name\":\"banana\"},{\"id\":53,\"name\":\"basmati rice\"},{\"id\":54,\"name\":\"bay leaves\"},{\"id\":55,\"name\":\"bbq sauce\"},{\"id\":56,\"name\":\"beans\"},{\"id\":57,\"name\":\"beef\"},{\"id\":58,\"name\":\"beef brisket\"},{\"id\":59,\"name\":\"beef broth\"},{\"id\":60,\"name\":\"beef chuck roast\"},{\"id\":61,\"name\":\"beef stock\"},{\"id\":62,\"name\":\"beef tenderloin\"},{\"id\":63,\"name\":\"beer\"},{\"id\":64,\"name\":\"beets\"},{\"id\":65,\"name\":\"bell pepper\"},{\"id\":66,\"name\":\"berries\"},{\"id\":67,\"name\":\"biscuit mix\"},{\"id\":68,\"name\":\"biscuits\"},{\"id\":69,\"name\":\"bittersweet chocolate\"},{\"id\":70,\"name\":\"black bean sauce\"},{\"id\":71,\"name\":\"black beans\"},{\"id\":72,\"name\":\"black olives\"},{\"id\":73,\"name\":\"black pepper\"},{\"id\":74,\"name\":\"black sesame seeds\"},{\"id\":75,\"name\":\"blackberries\"},{\"id\":76,\"name\":\"blanched almonds\"},{\"id\":77,\"name\":\"blood orange\"},{\"id\":78,\"name\":\"blue cheese\"},{\"id\":79,\"name\":\"blueberries\"},{\"id\":80,\"name\":\"bok choy\"},{\"id\":81,\"name\":\"boneless skinless chicken breast\"},{\"id\":82,\"name\":\"bourbon\"},{\"id\":83,\"name\":\"brandy\"},{\"id\":84,\"name\":\"bread\"},{\"id\":85,\"name\":\"bread flour\"},{\"id\":86,\"name\":\"breakfast links\"},{\"id\":87,\"name\":\"brie\"},{\"id\":88,\"name\":\"broccoli\"},{\"id\":89,\"name\":\"broccoli florets\"},{\"id\":90,\"name\":\"brown rice\"},{\"id\":91,\"name\":\"brown rice flour\"},{\"id\":92,\"name\":\"brown sugar\"},{\"id\":93,\"name\":\"brownie mix\"},{\"id\":94,\"name\":\"brussel sprouts\"},{\"id\":95,\"name\":\"bulgur\"},{\"id\":96,\"name\":\"butter\"},{\"id\":97,\"name\":\"butterhead lettuce\"},{\"id\":98,\"name\":\"buttermilk\"},{\"id\":99,\"name\":\"butternut squash\"},{\"id\":100,\"name\":\"butterscotch chips\"},{\"id\":101,\"name\":\"cabbage\"},{\"id\":102,\"name\":\"caesar dressing\"},{\"id\":103,\"name\":\"cajun seasoning\"},{\"id\":104,\"name\":\"cake flour\"},{\"id\":105,\"name\":\"candy canes\"},{\"id\":106,\"name\":\"candy coating\"},{\"id\":107,\"name\":\"candy melts\"},{\"id\":108,\"name\":\"canned black beans\"},{\"id\":109,\"name\":\"canned diced tomatoes\"},{\"id\":110,\"name\":\"canned garbanzo beans\"},{\"id\":111,\"name\":\"canned green chiles\"},{\"id\":112,\"name\":\"canned kidney beans\"},{\"id\":113,\"name\":\"canned mushrooms\"},{\"id\":114,\"name\":\"canned pinto beans\"},{\"id\":115,\"name\":\"canned red kidney beans\"},{\"id\":116,\"name\":\"canned tomatoes\"},{\"id\":117,\"name\":\"canned tuna\"},{\"id\":118,\"name\":\"canned white beans\"},{\"id\":119,\"name\":\"canned white cannellini beans\"},{\"id\":120,\"name\":\"cannellini beans\"},{\"id\":121,\"name\":\"cantaloupe\"},{\"id\":122,\"name\":\"capers\"},{\"id\":123,\"name\":\"caramel sauce\"},{\"id\":124,\"name\":\"caramels\"},{\"id\":125,\"name\":\"caraway seed\"},{\"id\":126,\"name\":\"cardamom\"},{\"id\":127,\"name\":\"cardamom pods\"},{\"id\":128,\"name\":\"carp\"},{\"id\":129,\"name\":\"carrots\"},{\"id\":130,\"name\":\"cat fish filets\"},{\"id\":131,\"name\":\"cauliflower\"},{\"id\":132,\"name\":\"cauliflower florets\"},{\"id\":133,\"name\":\"cauliflower rice\"},{\"id\":134,\"name\":\"celery\"},{\"id\":135,\"name\":\"celery ribs\"},{\"id\":136,\"name\":\"celery root\"},{\"id\":137,\"name\":\"celery salt\"},{\"id\":138,\"name\":\"celery seed\"},{\"id\":139,\"name\":\"cereal\"},{\"id\":140,\"name\":\"champagne\"},{\"id\":141,\"name\":\"chana dal\"},{\"id\":142,\"name\":\"cheddar\"},{\"id\":143,\"name\":\"cheese\"},{\"id\":144,\"name\":\"cheese curds\"},{\"id\":145,\"name\":\"cheese dip\"},{\"id\":146,\"name\":\"cheese soup\"},{\"id\":147,\"name\":\"cheese tortellini\"},{\"id\":148,\"name\":\"cherry\"},{\"id\":149,\"name\":\"cherry pie filling\"},{\"id\":150,\"name\":\"cherry tomatoes\"},{\"id\":151,\"name\":\"chestnuts\"},{\"id\":152,\"name\":\"chia seeds\"},{\"id\":153,\"name\":\"chicken base\"},{\"id\":154,\"name\":\"chicken bouillon\"},{\"id\":155,\"name\":\"chicken bouillon granules\"},{\"id\":156,\"name\":\"chicken breasts\"},{\"id\":157,\"name\":\"chicken broth\"},{\"id\":158,\"name\":\"chicken drumsticks\"},{\"id\":159,\"name\":\"chicken legs\"},{\"id\":160,\"name\":\"chicken pieces\"},{\"id\":161,\"name\":\"chicken sausage\"},{\"id\":162,\"name\":\"chicken stock\"},{\"id\":163,\"name\":\"chicken tenders\"},{\"id\":164,\"name\":\"chicken thighs\"},{\"id\":165,\"name\":\"chicken wings\"},{\"id\":166,\"name\":\"chickpea\"},{\"id\":167,\"name\":\"chile garlic sauce\"},{\"id\":168,\"name\":\"chili paste\"},{\"id\":169,\"name\":\"chili peppers\"},{\"id\":170,\"name\":\"chili powder\"},{\"id\":171,\"name\":\"chili sauce\"},{\"id\":172,\"name\":\"chipotle chiles in adobo\"},{\"id\":173,\"name\":\"chipotle chilies\"},{\"id\":174,\"name\":\"chipotle peppers in adobo\"},{\"id\":175,\"name\":\"chive & onion cream cheese spread\"},{\"id\":176,\"name\":\"chocolate\"},{\"id\":177,\"name\":\"chocolate chip cookies\"},{\"id\":178,\"name\":\"chocolate chunks\"},{\"id\":179,\"name\":\"chocolate ice cream\"},{\"id\":180,\"name\":\"chocolate milk\"},{\"id\":181,\"name\":\"chocolate sandwich cookies\"},{\"id\":182,\"name\":\"chocolate syrup\"},{\"id\":183,\"name\":\"chocolate wafer cookies\"},{\"id\":184,\"name\":\"chorizo sausage\"},{\"id\":185,\"name\":\"cider vinegar\"},{\"id\":186,\"name\":\"cilantro\"},{\"id\":187,\"name\":\"cinnamon roll\"},{\"id\":188,\"name\":\"cinnamon stick\"},{\"id\":189,\"name\":\"cinnamon sugar\"},{\"id\":190,\"name\":\"cinnamon swirl bread\"},{\"id\":191,\"name\":\"clam juice\"},{\"id\":192,\"name\":\"clams\"},{\"id\":193,\"name\":\"clarified butter\"},{\"id\":194,\"name\":\"clove\"},{\"id\":195,\"name\":\"coarse salt\"},{\"id\":196,\"name\":\"coarsely ground pepper\"},{\"id\":197,\"name\":\"cocoa nibs\"},{\"id\":198,\"name\":\"cocoa powder\"},{\"id\":199,\"name\":\"coconut\"},{\"id\":200,\"name\":\"coconut aminos\"},{\"id\":201,\"name\":\"coconut butter\"},{\"id\":202,\"name\":\"coconut cream\"},{\"id\":203,\"name\":\"coconut extract\"},{\"id\":204,\"name\":\"coconut flour\"},{\"id\":205,\"name\":\"coconut milk\"},{\"id\":206,\"name\":\"coconut oil\"},{\"id\":207,\"name\":\"coconut water\"},{\"id\":208,\"name\":\"cod\"},{\"id\":209,\"name\":\"coffee\"},{\"id\":210,\"name\":\"cognac\"},{\"id\":211,\"name\":\"cola\"},{\"id\":212,\"name\":\"colby jack\"},{\"id\":213,\"name\":\"collard greens\"},{\"id\":214,\"name\":\"condensed cream of celery soup\"},{\"id\":215,\"name\":\"condensed cream of mushroom soup\"},{\"id\":216,\"name\":\"confectioner's swerve\"},{\"id\":217,\"name\":\"cooked bacon\"},{\"id\":218,\"name\":\"cooked brown rice\"},{\"id\":219,\"name\":\"cooked chicken breast\"},{\"id\":220,\"name\":\"cooked ham\"},{\"id\":221,\"name\":\"cooked long grain rice\"},{\"id\":222,\"name\":\"cooked pasta\"},{\"id\":223,\"name\":\"cooked polenta\"},{\"id\":224,\"name\":\"cooked quinoa\"},{\"id\":225,\"name\":\"cooked wild rice\"},{\"id\":226,\"name\":\"cookies\"},{\"id\":227,\"name\":\"coriander\"},{\"id\":228,\"name\":\"corn\"},{\"id\":229,\"name\":\"corn bread mix\"},{\"id\":230,\"name\":\"corn chips\"},{\"id\":231,\"name\":\"corn flakes cereal\"},{\"id\":232,\"name\":\"corn flour\"},{\"id\":233,\"name\":\"corn kernels\"},{\"id\":234,\"name\":\"corn oil\"},{\"id\":235,\"name\":\"corn tortillas\"},{\"id\":236,\"name\":\"cornbread\"},{\"id\":237,\"name\":\"corned beef\"},{\"id\":238,\"name\":\"cornish hens\"},{\"id\":239,\"name\":\"cornmeal\"},{\"id\":240,\"name\":\"cornstarch\"},{\"id\":241,\"name\":\"cotija cheese\"},{\"id\":242,\"name\":\"cottage cheese\"},{\"id\":243,\"name\":\"country bread\"},{\"id\":244,\"name\":\"courgettes\"},{\"id\":245,\"name\":\"couscous\"},{\"id\":246,\"name\":\"cow pea\"},{\"id\":247,\"name\":\"crabmeat\"},{\"id\":248,\"name\":\"cracked pepper\"},{\"id\":249,\"name\":\"cranberries\"},{\"id\":250,\"name\":\"cranberry juice\"},{\"id\":251,\"name\":\"cream\"},{\"id\":252,\"name\":\"cream cheese\"},{\"id\":253,\"name\":\"cream cheese block\"},{\"id\":254,\"name\":\"cream of chicken soup\"},{\"id\":255,\"name\":\"cream of tartar\"},{\"id\":256,\"name\":\"creamed corn\"},{\"id\":257,\"name\":\"creamy peanut butter\"},{\"id\":258,\"name\":\"creme fraiche\"},{\"id\":259,\"name\":\"cremini mushrooms\"},{\"id\":260,\"name\":\"creole seasoning\"},{\"id\":261,\"name\":\"crisp rice cereal\"},{\"id\":262,\"name\":\"croutons\"},{\"id\":263,\"name\":\"crystallized ginger\"},{\"id\":264,\"name\":\"cucumber\"},{\"id\":265,\"name\":\"cumin seeds\"},{\"id\":266,\"name\":\"cup cake\"},{\"id\":267,\"name\":\"currants\"},{\"id\":268,\"name\":\"curry leaves\"},{\"id\":269,\"name\":\"dairy free milk\"},{\"id\":270,\"name\":\"dark brown sugar\"},{\"id\":271,\"name\":\"dark chocolate\"},{\"id\":272,\"name\":\"dark chocolate candy bars\"},{\"id\":273,\"name\":\"dark chocolate chips\"},{\"id\":274,\"name\":\"dark sesame oil\"},{\"id\":275,\"name\":\"dates\"},{\"id\":276,\"name\":\"deep dish pie crust\"},{\"id\":277,\"name\":\"deli ham\"},{\"id\":278,\"name\":\"deli turkey\"},{\"id\":279,\"name\":\"dessert oats\"},{\"id\":280,\"name\":\"dessert wine\"},{\"id\":281,\"name\":\"diced ham\"},{\"id\":282,\"name\":\"diet pop\"},{\"id\":283,\"name\":\"dijon mustard\"},{\"id\":284,\"name\":\"dill\"},{\"id\":285,\"name\":\"dill pickles\"},{\"id\":286,\"name\":\"dog\"},{\"id\":287,\"name\":\"double cream\"},{\"id\":288,\"name\":\"dried apricots\"},{\"id\":289,\"name\":\"dried basil\"},{\"id\":290,\"name\":\"dried cherries\"},{\"id\":291,\"name\":\"dried chorizo\"},{\"id\":292,\"name\":\"dried cranberries\"},{\"id\":293,\"name\":\"dried dill\"},{\"id\":294,\"name\":\"dried onion\"},{\"id\":295,\"name\":\"dried porcini mushrooms\"},{\"id\":296,\"name\":\"dried rubbed sage\"},{\"id\":297,\"name\":\"dried thyme\"},{\"id\":298,\"name\":\"dried tomatoes\"},{\"id\":299,\"name\":\"dry bread crumbs\"},{\"id\":300,\"name\":\"dry milk\"},{\"id\":301,\"name\":\"dry mustard\"},{\"id\":302,\"name\":\"dry red wine\"},{\"id\":303,\"name\":\"dry roasted peanuts\"},{\"id\":304,\"name\":\"duck fat\"},{\"id\":305,\"name\":\"dutch process cocoa powder\"},{\"id\":306,\"name\":\"edamame\"},{\"id\":307,\"name\":\"egg substitute\"},{\"id\":308,\"name\":\"egg vermicelli\"},{\"id\":309,\"name\":\"egg whites\"},{\"id\":310,\"name\":\"egg yolk\"},{\"id\":311,\"name\":\"eggnog\"},{\"id\":312,\"name\":\"eggplant\"},{\"id\":313,\"name\":\"elbow macaroni\"},{\"id\":314,\"name\":\"enchilada sauce\"},{\"id\":315,\"name\":\"english cucumber\"},{\"id\":316,\"name\":\"english muffin\"},{\"id\":317,\"name\":\"erythritol\"},{\"id\":318,\"name\":\"escarole\"},{\"id\":319,\"name\":\"espresso\"},{\"id\":320,\"name\":\"evaporated milk\"},{\"id\":321,\"name\":\"extra firm tofu\"},{\"id\":322,\"name\":\"extra virgin olive oil\"},{\"id\":323,\"name\":\"farfalle\"},{\"id\":324,\"name\":\"farro\"},{\"id\":325,\"name\":\"fat free mayo\"},{\"id\":326,\"name\":\"fat-free less-sodium chicken broth\"},{\"id\":327,\"name\":\"fennel\"},{\"id\":328,\"name\":\"fennel seeds\"},{\"id\":329,\"name\":\"fenugreek leaf\"},{\"id\":330,\"name\":\"fenugreek seeds\"},{\"id\":331,\"name\":\"feta cheese\"},{\"id\":332,\"name\":\"fettuccine\"},{\"id\":333,\"name\":\"fire roasted tomatoes\"},{\"id\":334,\"name\":\"fish\"},{\"id\":335,\"name\":\"fish sauce\"},{\"id\":336,\"name\":\"fish stock\"},{\"id\":337,\"name\":\"flank steak\"},{\"id\":338,\"name\":\"flax seeds\"},{\"id\":339,\"name\":\"fleur de sel\"},{\"id\":340,\"name\":\"flour\"},{\"id\":341,\"name\":\"flour tortillas\"},{\"id\":342,\"name\":\"fontina cheese\"},{\"id\":343,\"name\":\"food dye\"},{\"id\":344,\"name\":\"frank's redhot sauce\"},{\"id\":345,\"name\":\"free range eggs\"},{\"id\":346,\"name\":\"french bread\"},{\"id\":347,\"name\":\"fresh basil\"},{\"id\":348,\"name\":\"fresh bean sprouts\"},{\"id\":349,\"name\":\"fresh chives\"},{\"id\":350,\"name\":\"fresh corn\"},{\"id\":351,\"name\":\"fresh corn kernels\"},{\"id\":352,\"name\":\"fresh figs\"},{\"id\":353,\"name\":\"fresh fruit\"},{\"id\":354,\"name\":\"fresh herbs\"},{\"id\":355,\"name\":\"fresh mint\"},{\"id\":356,\"name\":\"fresh mozzarella\"},{\"id\":357,\"name\":\"fresh rosemary\"},{\"id\":358,\"name\":\"fresh thyme leaves\"},{\"id\":359,\"name\":\"fried onions\"},{\"id\":360,\"name\":\"frosting\"},{\"id\":361,\"name\":\"froyo bars\"},{\"id\":362,\"name\":\"frozen corn\"},{\"id\":363,\"name\":\"frozen spinach\"},{\"id\":364,\"name\":\"fudge\"},{\"id\":365,\"name\":\"fudge topping\"},{\"id\":366,\"name\":\"fun size almond joy bar\"},{\"id\":367,\"name\":\"garam masala\"},{\"id\":368,\"name\":\"garbanzo bean flour\"},{\"id\":369,\"name\":\"garlic\"},{\"id\":370,\"name\":\"garlic paste\"},{\"id\":371,\"name\":\"garlic powder\"},{\"id\":372,\"name\":\"garlic salt\"},{\"id\":373,\"name\":\"gelatin\"},{\"id\":374,\"name\":\"gf chocolate cake mix\"},{\"id\":375,\"name\":\"gin\"},{\"id\":376,\"name\":\"ginger\"},{\"id\":377,\"name\":\"ginger ale\"},{\"id\":378,\"name\":\"ginger paste\"},{\"id\":379,\"name\":\"ginger-garlic paste\"},{\"id\":380,\"name\":\"gingersnap cookies\"},{\"id\":381,\"name\":\"gnocchi\"},{\"id\":382,\"name\":\"goat cheese\"},{\"id\":383,\"name\":\"golden raisins\"},{\"id\":384,\"name\":\"gorgonzola\"},{\"id\":385,\"name\":\"gouda cheese\"},{\"id\":386,\"name\":\"graham cracker crumbs\"},{\"id\":387,\"name\":\"graham cracker pie crust\"},{\"id\":388,\"name\":\"graham crackers\"},{\"id\":389,\"name\":\"grain blend\"},{\"id\":390,\"name\":\"grand marnier\"},{\"id\":391,\"name\":\"granny smith apples\"},{\"id\":392,\"name\":\"granola\"},{\"id\":393,\"name\":\"granulated garlic\"},{\"id\":394,\"name\":\"grape tomatoes\"},{\"id\":395,\"name\":\"grapefruit\"},{\"id\":396,\"name\":\"grapeseed oil\"},{\"id\":397,\"name\":\"gravy\"},{\"id\":398,\"name\":\"great northern beans\"},{\"id\":399,\"name\":\"greek yogurt\"},{\"id\":400,\"name\":\"green beans\"},{\"id\":401,\"name\":\"green bell pepper\"},{\"id\":402,\"name\":\"green chili pepper\"},{\"id\":403,\"name\":\"green food coloring\"},{\"id\":404,\"name\":\"green grapes\"},{\"id\":405,\"name\":\"green olives\"},{\"id\":406,\"name\":\"green onions\"},{\"id\":407,\"name\":\"greens\"},{\"id\":408,\"name\":\"grill cheese\"},{\"id\":409,\"name\":\"grill seasoning\"},{\"id\":410,\"name\":\"ground allspice\"},{\"id\":411,\"name\":\"ground ancho chili\"},{\"id\":412,\"name\":\"ground beef\"},{\"id\":413,\"name\":\"ground chicken\"},{\"id\":414,\"name\":\"ground chipotle chile pepper\"},{\"id\":415,\"name\":\"ground cinnamon\"},{\"id\":416,\"name\":\"ground cloves\"},{\"id\":417,\"name\":\"ground coriander seeds\"},{\"id\":418,\"name\":\"ground cumin\"},{\"id\":419,\"name\":\"ground flaxseed\"},{\"id\":420,\"name\":\"ground ginger\"},{\"id\":421,\"name\":\"ground lamb\"},{\"id\":422,\"name\":\"ground mace\"},{\"id\":423,\"name\":\"ground nutmeg\"},{\"id\":424,\"name\":\"ground pork\"},{\"id\":425,\"name\":\"ground pork sausage\"},{\"id\":426,\"name\":\"ground veal\"},{\"id\":427,\"name\":\"gruyere\"},{\"id\":428,\"name\":\"guacamole\"},{\"id\":429,\"name\":\"half n half\"},{\"id\":430,\"name\":\"halibut fillet\"},{\"id\":431,\"name\":\"ham\"},{\"id\":432,\"name\":\"hamburger buns\"},{\"id\":433,\"name\":\"hard cooked eggs\"},{\"id\":434,\"name\":\"harissa\"},{\"id\":435,\"name\":\"hash brown potatoes\"},{\"id\":436,\"name\":\"hazelnuts\"},{\"id\":437,\"name\":\"healthy request cream of celery soup\"},{\"id\":438,\"name\":\"hemp seeds\"},{\"id\":439,\"name\":\"herbes de provence\"},{\"id\":440,\"name\":\"herbs\"},{\"id\":441,\"name\":\"hershey's kisses brand milk chocolates\"},{\"id\":442,\"name\":\"hoisin sauce\"},{\"id\":443,\"name\":\"honey mustard\"},{\"id\":444,\"name\":\"horseradish\"},{\"id\":445,\"name\":\"hot sauce\"},{\"id\":446,\"name\":\"hummus\"},{\"id\":447,\"name\":\"ice\"},{\"id\":448,\"name\":\"ice cream\"},{\"id\":449,\"name\":\"instant chocolate pudding mix\"},{\"id\":450,\"name\":\"instant coffee powder\"},{\"id\":451,\"name\":\"instant espresso powder\"},{\"id\":452,\"name\":\"instant lemon pudding mix\"},{\"id\":453,\"name\":\"instant yeast\"},{\"id\":454,\"name\":\"irish cream\"},{\"id\":455,\"name\":\"italian bread\"},{\"id\":456,\"name\":\"italian cheese blend\"},{\"id\":457,\"name\":\"italian sausages\"},{\"id\":458,\"name\":\"italian seasoning\"},{\"id\":459,\"name\":\"jaggery\"},{\"id\":460,\"name\":\"jalapeno\"},{\"id\":461,\"name\":\"jasmine rice\"},{\"id\":462,\"name\":\"jelly\"},{\"id\":463,\"name\":\"jicama\"},{\"id\":464,\"name\":\"jimmies\"},{\"id\":465,\"name\":\"juice\"},{\"id\":466,\"name\":\"jumbo shell pasta\"},{\"id\":467,\"name\":\"kaffir lime leaves\"},{\"id\":468,\"name\":\"kahlua\"},{\"id\":469,\"name\":\"kalamata olives\"},{\"id\":470,\"name\":\"kale\"},{\"id\":471,\"name\":\"ketchup\"},{\"id\":472,\"name\":\"kitchen bouquet\"},{\"id\":473,\"name\":\"kiwis\"},{\"id\":474,\"name\":\"kosher salt\"},{\"id\":475,\"name\":\"ladyfingers\"},{\"id\":476,\"name\":\"lamb\"},{\"id\":477,\"name\":\"lasagna noodles\"},{\"id\":478,\"name\":\"lb cake\"},{\"id\":479,\"name\":\"lean ground beef\"},{\"id\":480,\"name\":\"lean ground turkey\"},{\"id\":481,\"name\":\"lean pork tenderloin\"},{\"id\":482,\"name\":\"leeks\"},{\"id\":483,\"name\":\"leg of lamb\"},{\"id\":484,\"name\":\"lemon\"},{\"id\":485,\"name\":\"lemon curd\"},{\"id\":486,\"name\":\"lemon extract\"},{\"id\":487,\"name\":\"lemon juice\"},{\"id\":488,\"name\":\"lemon peel\"},{\"id\":489,\"name\":\"lemon pepper\"},{\"id\":490,\"name\":\"lemon wedges\"},{\"id\":491,\"name\":\"lemongrass\"},{\"id\":492,\"name\":\"lettuce\"},{\"id\":493,\"name\":\"lettuce leaves\"},{\"id\":494,\"name\":\"light butter\"},{\"id\":495,\"name\":\"light coconut milk\"},{\"id\":496,\"name\":\"light corn syrup\"},{\"id\":497,\"name\":\"light cream cheese\"},{\"id\":498,\"name\":\"light mayonnaise\"},{\"id\":499,\"name\":\"light olive oil\"},{\"id\":500,\"name\":\"light soy sauce\"},{\"id\":501,\"name\":\"lime\"},{\"id\":502,\"name\":\"lime juice\"},{\"id\":503,\"name\":\"lime wedges\"},{\"id\":504,\"name\":\"lime zest\"},{\"id\":505,\"name\":\"linguine\"},{\"id\":506,\"name\":\"liquid smoke\"},{\"id\":507,\"name\":\"liquid stevia\"},{\"id\":508,\"name\":\"liquor\"},{\"id\":509,\"name\":\"live lobster\"},{\"id\":510,\"name\":\"long-grain rice\"},{\"id\":511,\"name\":\"low fat buttermilk\"},{\"id\":512,\"name\":\"low fat milk\"},{\"id\":513,\"name\":\"low fat plain yogurt\"},{\"id\":514,\"name\":\"low fat ricotta cheese\"},{\"id\":515,\"name\":\"low fat sour cream\"},{\"id\":516,\"name\":\"low sodium chicken broth\"},{\"id\":517,\"name\":\"low sodium soy sauce\"},{\"id\":518,\"name\":\"low-sodium chicken stock\"},{\"id\":519,\"name\":\"lower sodium beef broth\"},{\"id\":520,\"name\":\"lump crab\"},{\"id\":521,\"name\":\"m&m candies\"},{\"id\":522,\"name\":\"macadamia nuts\"},{\"id\":523,\"name\":\"macaroni and cheese mix\"},{\"id\":524,\"name\":\"madras curry powder\"},{\"id\":525,\"name\":\"malt drink mix\"},{\"id\":526,\"name\":\"mandarin orange sections\"},{\"id\":527,\"name\":\"mandarin oranges\"},{\"id\":528,\"name\":\"mango\"},{\"id\":529,\"name\":\"maple syrup\"},{\"id\":530,\"name\":\"maraschino cherries\"},{\"id\":531,\"name\":\"margarine\"},{\"id\":532,\"name\":\"marinara sauce\"},{\"id\":533,\"name\":\"marjoram\"},{\"id\":534,\"name\":\"marsala wine\"},{\"id\":535,\"name\":\"marshmallow fluff\"},{\"id\":536,\"name\":\"marshmallows\"},{\"id\":537,\"name\":\"masa harina\"},{\"id\":538,\"name\":\"mascarpone\"},{\"id\":539,\"name\":\"mat beans\"},{\"id\":540,\"name\":\"matcha tea\"},{\"id\":541,\"name\":\"mayonnaise\"},{\"id\":542,\"name\":\"meat\"},{\"id\":543,\"name\":\"meatballs\"},{\"id\":544,\"name\":\"medjool dates\"},{\"id\":545,\"name\":\"mexican cream\"},{\"id\":546,\"name\":\"meyer lemon juice\"},{\"id\":547,\"name\":\"milk\"},{\"id\":548,\"name\":\"milk chocolate chips\"},{\"id\":549,\"name\":\"mint chutney\"},{\"id\":550,\"name\":\"minute rice\"},{\"id\":551,\"name\":\"miracle whip\"},{\"id\":552,\"name\":\"mirin\"},{\"id\":553,\"name\":\"miso\"},{\"id\":554,\"name\":\"molasses\"},{\"id\":555,\"name\":\"monterey jack cheese\"},{\"id\":556,\"name\":\"mushroom\"},{\"id\":557,\"name\":\"mussels\"},{\"id\":558,\"name\":\"mustard\"},{\"id\":559,\"name\":\"mustard seeds\"},{\"id\":560,\"name\":\"napa cabbage\"},{\"id\":561,\"name\":\"navel oranges\"},{\"id\":562,\"name\":\"nectarine\"},{\"id\":563,\"name\":\"new potatoes\"},{\"id\":564,\"name\":\"non-fat greek yogurt\"},{\"id\":565,\"name\":\"nonfat cool whip\"},{\"id\":566,\"name\":\"nonfat milk\"},{\"id\":567,\"name\":\"nori\"},{\"id\":568,\"name\":\"nut butter\"},{\"id\":569,\"name\":\"nut meal\"},{\"id\":570,\"name\":\"nutella\"},{\"id\":571,\"name\":\"nutritional yeast\"},{\"id\":572,\"name\":\"oat flour\"},{\"id\":573,\"name\":\"oats\"},{\"id\":574,\"name\":\"oil\"},{\"id\":575,\"name\":\"oil packed sun dried tomatoes\"},{\"id\":576,\"name\":\"okra\"},{\"id\":577,\"name\":\"old bay seasoning\"},{\"id\":578,\"name\":\"olive oil\"},{\"id\":579,\"name\":\"olives\"},{\"id\":580,\"name\":\"onion\"},{\"id\":581,\"name\":\"onion powder\"},{\"id\":582,\"name\":\"onion soup mix\"},{\"id\":583,\"name\":\"orange\"},{\"id\":584,\"name\":\"orange bell pepper\"},{\"id\":585,\"name\":\"orange juice\"},{\"id\":586,\"name\":\"orange juice concentrate\"},{\"id\":587,\"name\":\"orange liqueur\"},{\"id\":588,\"name\":\"orange marmalade\"},{\"id\":589,\"name\":\"orange oil\"},{\"id\":590,\"name\":\"orange zest\"},{\"id\":591,\"name\":\"oregano\"},{\"id\":592,\"name\":\"oreo cookies\"},{\"id\":593,\"name\":\"orzo\"},{\"id\":594,\"name\":\"oyster sauce\"},{\"id\":595,\"name\":\"oysters\"},{\"id\":596,\"name\":\"palm sugar\"},{\"id\":597,\"name\":\"pancetta\"},{\"id\":598,\"name\":\"paneer\"},{\"id\":599,\"name\":\"panko\"},{\"id\":600,\"name\":\"papaya\"},{\"id\":601,\"name\":\"paprika\"},{\"id\":602,\"name\":\"parmigiano reggiano\"},{\"id\":603,\"name\":\"parsley\"},{\"id\":604,\"name\":\"parsley flakes\"},{\"id\":605,\"name\":\"parsnip\"},{\"id\":606,\"name\":\"part-skim mozzarella cheese\"},{\"id\":607,\"name\":\"pasta\"},{\"id\":608,\"name\":\"pasta salad mix\"},{\"id\":609,\"name\":\"pasta sauce\"},{\"id\":610,\"name\":\"pastry flour\"},{\"id\":611,\"name\":\"peach\"},{\"id\":612,\"name\":\"peanut butter\"},{\"id\":613,\"name\":\"peanut butter chips\"},{\"id\":614,\"name\":\"peanut butter cups\"},{\"id\":615,\"name\":\"peanut oil\"},{\"id\":616,\"name\":\"peanuts\"},{\"id\":617,\"name\":\"pear liqueur\"},{\"id\":618,\"name\":\"pearl barley\"},{\"id\":619,\"name\":\"pearl onions\"},{\"id\":620,\"name\":\"peas\"},{\"id\":621,\"name\":\"pecan\"},{\"id\":622,\"name\":\"pecan pieces\"},{\"id\":623,\"name\":\"pecorino\"},{\"id\":624,\"name\":\"penne\"},{\"id\":625,\"name\":\"peperoncino\"},{\"id\":626,\"name\":\"pepper jack cheese\"},{\"id\":627,\"name\":\"peppercorns\"},{\"id\":628,\"name\":\"peppermint baking chips\"},{\"id\":629,\"name\":\"peppermint extract\"},{\"id\":630,\"name\":\"pepperoni\"},{\"id\":631,\"name\":\"peppers\"},{\"id\":632,\"name\":\"pesto\"},{\"id\":633,\"name\":\"pickle relish\"},{\"id\":634,\"name\":\"pickles\"},{\"id\":635,\"name\":\"pico de gallo\"},{\"id\":636,\"name\":\"pie crust\"},{\"id\":637,\"name\":\"pimento stuffed olives\"},{\"id\":638,\"name\":\"pimientos\"},{\"id\":639,\"name\":\"pine nuts\"},{\"id\":640,\"name\":\"pineapple\"},{\"id\":641,\"name\":\"pineapple chunks\"},{\"id\":642,\"name\":\"pineapple in juice\"},{\"id\":643,\"name\":\"pineapple juice\"},{\"id\":644,\"name\":\"pink himalayan salt\"},{\"id\":645,\"name\":\"pinto beans\"},{\"id\":646,\"name\":\"pistachios\"},{\"id\":647,\"name\":\"pita\"},{\"id\":648,\"name\":\"pizza crust\"},{\"id\":649,\"name\":\"pizza mix\"},{\"id\":650,\"name\":\"plain greek yogurt\"},{\"id\":651,\"name\":\"plain nonfat yogurt\"},{\"id\":652,\"name\":\"plain yogurt\"},{\"id\":653,\"name\":\"plantain\"},{\"id\":654,\"name\":\"plum\"},{\"id\":655,\"name\":\"plum tomatoes\"},{\"id\":656,\"name\":\"poblano peppers\"},{\"id\":657,\"name\":\"polenta\"},{\"id\":658,\"name\":\"polish sausage\"},{\"id\":659,\"name\":\"pomegranate juice\"},{\"id\":660,\"name\":\"pomegranate molasses\"},{\"id\":661,\"name\":\"pomegranate seeds\"},{\"id\":662,\"name\":\"popcorn\"},{\"id\":663,\"name\":\"poppy seeds\"},{\"id\":664,\"name\":\"pork\"},{\"id\":665,\"name\":\"Pork & Beans\"},{\"id\":666,\"name\":\"pork belly\"},{\"id\":667,\"name\":\"pork butt\"},{\"id\":668,\"name\":\"pork chops\"},{\"id\":669,\"name\":\"pork links\"},{\"id\":670,\"name\":\"pork loin chops\"},{\"id\":671,\"name\":\"pork loin roast\"},{\"id\":672,\"name\":\"pork roast\"},{\"id\":673,\"name\":\"pork shoulder\"},{\"id\":674,\"name\":\"pork tenderloin\"},{\"id\":675,\"name\":\"port\"},{\"id\":676,\"name\":\"portabella mushrooms\"},{\"id\":677,\"name\":\"pot roast\"},{\"id\":678,\"name\":\"potato chips\"},{\"id\":679,\"name\":\"potato starch\"},{\"id\":680,\"name\":\"potatoes\"},{\"id\":681,\"name\":\"poultry seasoning\"},{\"id\":682,\"name\":\"powdered sugar\"},{\"id\":683,\"name\":\"pretzel sandwiches\"},{\"id\":684,\"name\":\"processed american cheese\"},{\"id\":685,\"name\":\"prosciutto\"},{\"id\":686,\"name\":\"provolone cheese\"},{\"id\":687,\"name\":\"prunes\"},{\"id\":688,\"name\":\"puff pastry\"},{\"id\":689,\"name\":\"pumpkin\"},{\"id\":690,\"name\":\"pumpkin pie filling\"},{\"id\":691,\"name\":\"pumpkin pie spice\"},{\"id\":692,\"name\":\"pumpkin puree\"},{\"id\":693,\"name\":\"pumpkin seeds\"},{\"id\":694,\"name\":\"queso fresco\"},{\"id\":695,\"name\":\"quick cooking oats\"},{\"id\":696,\"name\":\"quinoa\"},{\"id\":697,\"name\":\"quinoa flour\"},{\"id\":698,\"name\":\"radicchio\"},{\"id\":699,\"name\":\"radishes\"},{\"id\":700,\"name\":\"raisins\"},{\"id\":701,\"name\":\"rajma masala\"},{\"id\":702,\"name\":\"ramen noodles\"},{\"id\":703,\"name\":\"ranch dressing\"},{\"id\":704,\"name\":\"ranch dressing mix\"},{\"id\":705,\"name\":\"raspberries\"},{\"id\":706,\"name\":\"raspberry jam\"},{\"id\":707,\"name\":\"raw cashews\"},{\"id\":708,\"name\":\"raw shrimp\"},{\"id\":709,\"name\":\"ready-to-serve Asian fried rice\"},{\"id\":710,\"name\":\"real bacon recipe pieces\"},{\"id\":711,\"name\":\"red apples\"},{\"id\":712,\"name\":\"red bell peppers\"},{\"id\":713,\"name\":\"red cabbage\"},{\"id\":714,\"name\":\"red chilli\"},{\"id\":715,\"name\":\"red delicious apples\"},{\"id\":716,\"name\":\"red food coloring\"},{\"id\":717,\"name\":\"red grapefruit juice\"},{\"id\":718,\"name\":\"red grapes\"},{\"id\":719,\"name\":\"red kidney beans\"},{\"id\":720,\"name\":\"red lentils\"},{\"id\":721,\"name\":\"red onion\"},{\"id\":722,\"name\":\"red pepper flakes\"},{\"id\":723,\"name\":\"red pepper powder\"},{\"id\":724,\"name\":\"red potatoes\"},{\"id\":725,\"name\":\"red velvet cookie\"},{\"id\":726,\"name\":\"red wine\"},{\"id\":727,\"name\":\"red wine vinegar\"},{\"id\":728,\"name\":\"reduced fat shredded cheddar cheese\"},{\"id\":729,\"name\":\"refried beans\"},{\"id\":730,\"name\":\"refrigerated crescent rolls\"},{\"id\":731,\"name\":\"refrigerated pizza dough\"},{\"id\":732,\"name\":\"refrigerated sugar cookie dough\"},{\"id\":733,\"name\":\"rhubarb\"},{\"id\":734,\"name\":\"rib tips\"},{\"id\":735,\"name\":\"rice\"},{\"id\":736,\"name\":\"rice flour\"},{\"id\":737,\"name\":\"rice krispies cereal\"},{\"id\":738,\"name\":\"rice milk\"},{\"id\":739,\"name\":\"rice noodles\"},{\"id\":740,\"name\":\"rice paper\"},{\"id\":741,\"name\":\"rice syrup\"},{\"id\":742,\"name\":\"rice vinegar\"},{\"id\":743,\"name\":\"rice wine\"},{\"id\":744,\"name\":\"ricotta salata\"},{\"id\":745,\"name\":\"ritz crackers\"},{\"id\":746,\"name\":\"roast beef\"},{\"id\":747,\"name\":\"roasted chicken\"},{\"id\":748,\"name\":\"roasted nuts\"},{\"id\":749,\"name\":\"roasted peanuts\"},{\"id\":750,\"name\":\"roasted red peppers\"},{\"id\":751,\"name\":\"roma tomatoes\"},{\"id\":752,\"name\":\"romaine lettuce\"},{\"id\":753,\"name\":\"root vegetables\"},{\"id\":754,\"name\":\"rosemary\"},{\"id\":755,\"name\":\"rotini pasta\"},{\"id\":756,\"name\":\"rotisserie chicken\"},{\"id\":757,\"name\":\"round steak\"},{\"id\":758,\"name\":\"rub\"},{\"id\":759,\"name\":\"rum extract\"},{\"id\":760,\"name\":\"runny honey\"},{\"id\":761,\"name\":\"russet potatoes\"},{\"id\":762,\"name\":\"rutabaga\"},{\"id\":763,\"name\":\"rye bread\"},{\"id\":764,\"name\":\"rye meal\"},{\"id\":765,\"name\":\"saffron threads\"},{\"id\":766,\"name\":\"sage\"},{\"id\":767,\"name\":\"sage leaves\"},{\"id\":768,\"name\":\"salad dressing\"},{\"id\":769,\"name\":\"salami\"},{\"id\":770,\"name\":\"salmon fillet\"},{\"id\":771,\"name\":\"salsa\"},{\"id\":772,\"name\":\"salsa verde\"},{\"id\":773,\"name\":\"salt\"},{\"id\":774,\"name\":\"salt and pepper\"},{\"id\":775,\"name\":\"salted butter\"},{\"id\":776,\"name\":\"saltine crackers\"},{\"id\":777,\"name\":\"sandwich bun\"},{\"id\":778,\"name\":\"sauerkraut\"},{\"id\":779,\"name\":\"sausage\"},{\"id\":780,\"name\":\"sausage links\"},{\"id\":781,\"name\":\"scotch bonnet chili\"},{\"id\":782,\"name\":\"sea salt\"},{\"id\":783,\"name\":\"sea scallops\"},{\"id\":784,\"name\":\"seasoned bread crumbs\"},{\"id\":785,\"name\":\"seasoned rice vinegar\"},{\"id\":786,\"name\":\"seasoned salt\"},{\"id\":787,\"name\":\"seasoning\"},{\"id\":788,\"name\":\"seasoning blend\"},{\"id\":789,\"name\":\"seeds\"},{\"id\":790,\"name\":\"self-rising flour\"},{\"id\":791,\"name\":\"semi sweet chocolate chips\"},{\"id\":792,\"name\":\"serrano chile\"},{\"id\":793,\"name\":\"sesame oil\"},{\"id\":794,\"name\":\"sesame seed hamburger buns\"},{\"id\":795,\"name\":\"sesame seeds\"},{\"id\":796,\"name\":\"shallot\"},{\"id\":797,\"name\":\"sharp cheddar cheese\"},{\"id\":798,\"name\":\"sheeps milk cheese\"},{\"id\":799,\"name\":\"shells\"},{\"id\":800,\"name\":\"sherry\"},{\"id\":801,\"name\":\"sherry vinegar\"},{\"id\":802,\"name\":\"shiitake mushroom caps\"},{\"id\":803,\"name\":\"short grain rice\"},{\"id\":804,\"name\":\"short pasta\"},{\"id\":805,\"name\":\"short ribs\"},{\"id\":806,\"name\":\"shortbread cookies\"},{\"id\":807,\"name\":\"shortcrust pastry\"},{\"id\":808,\"name\":\"shortening\"},{\"id\":809,\"name\":\"shredded cheddar cheese\"},{\"id\":810,\"name\":\"shredded cheese\"},{\"id\":811,\"name\":\"shredded chicken\"},{\"id\":812,\"name\":\"shredded coconut\"},{\"id\":813,\"name\":\"shredded mexican cheese blend\"},{\"id\":814,\"name\":\"shredded mozzarella\"},{\"id\":815,\"name\":\"silken tofu\"},{\"id\":816,\"name\":\"sirloin steak\"},{\"id\":817,\"name\":\"skim milk ricotta\"},{\"id\":818,\"name\":\"skim vanilla greek yogurt\"},{\"id\":819,\"name\":\"skin-on bone-in chicken leg quarters\"},{\"id\":820,\"name\":\"skinless boneless chicken breast halves\"},{\"id\":821,\"name\":\"skinless boneless chicken thighs\"},{\"id\":822,\"name\":\"skinned black gram\"},{\"id\":823,\"name\":\"slaw dressing\"},{\"id\":824,\"name\":\"slaw mix\"},{\"id\":825,\"name\":\"slivered almonds\"},{\"id\":826,\"name\":\"smoked paprika\"},{\"id\":827,\"name\":\"smoked salmon\"},{\"id\":828,\"name\":\"smoked sausage\"},{\"id\":829,\"name\":\"smooth peanut butter\"},{\"id\":830,\"name\":\"snapper fillets\"},{\"id\":831,\"name\":\"snow peas\"},{\"id\":832,\"name\":\"soda water\"},{\"id\":833,\"name\":\"sour cream\"},{\"id\":834,\"name\":\"sourdough bowl\"},{\"id\":835,\"name\":\"sourdough bread\"},{\"id\":836,\"name\":\"soy milk\"},{\"id\":837,\"name\":\"soy protein powder\"},{\"id\":838,\"name\":\"soy sauce\"},{\"id\":839,\"name\":\"spaghetti\"},{\"id\":840,\"name\":\"spaghetti squash\"},{\"id\":841,\"name\":\"sparkling wine\"},{\"id\":842,\"name\":\"spelt flour\"},{\"id\":843,\"name\":\"spicy brown mustard\"},{\"id\":844,\"name\":\"spinach\"},{\"id\":845,\"name\":\"sprite\"},{\"id\":846,\"name\":\"sprouts\"},{\"id\":847,\"name\":\"squash\"},{\"id\":848,\"name\":\"sriracha sauce\"},{\"id\":849,\"name\":\"steaks\"},{\"id\":850,\"name\":\"steel cut oats\"},{\"id\":851,\"name\":\"stevia\"},{\"id\":852,\"name\":\"stew meat\"},{\"id\":853,\"name\":\"stew vegetables\"},{\"id\":854,\"name\":\"stock\"},{\"id\":855,\"name\":\"store-bought phyllo\"},{\"id\":856,\"name\":\"stout\"},{\"id\":857,\"name\":\"strawberries\"},{\"id\":858,\"name\":\"strawberry jam\"},{\"id\":859,\"name\":\"strawberry jello\"},{\"id\":860,\"name\":\"stuffing\"},{\"id\":861,\"name\":\"stuffing mix\"},{\"id\":862,\"name\":\"sub rolls\"},{\"id\":863,\"name\":\"sugar\"},{\"id\":864,\"name\":\"sugar snap peas\"},{\"id\":865,\"name\":\"sugar syrup\"},{\"id\":866,\"name\":\"sukrin sweetener\"},{\"id\":867,\"name\":\"summer savory\"},{\"id\":868,\"name\":\"summer squash\"},{\"id\":869,\"name\":\"sunflower oil\"},{\"id\":870,\"name\":\"sunflower seeds\"},{\"id\":871,\"name\":\"sweet chilli sauce\"},{\"id\":872,\"name\":\"sweet onion\"},{\"id\":873,\"name\":\"sweet paprika\"},{\"id\":874,\"name\":\"sweet pickle juice\"},{\"id\":875,\"name\":\"sweet pickle relish\"},{\"id\":876,\"name\":\"sweet potato\"},{\"id\":877,\"name\":\"sweet tea\"},{\"id\":878,\"name\":\"sweetened coconut\"},{\"id\":879,\"name\":\"sweetened condensed milk\"},{\"id\":880,\"name\":\"sweetened shredded coconut\"},{\"id\":881,\"name\":\"swiss chard\"},{\"id\":882,\"name\":\"swiss cheese\"},{\"id\":883,\"name\":\"taco seasoning mix\"},{\"id\":884,\"name\":\"taco shells\"},{\"id\":885,\"name\":\"tahini\"},{\"id\":886,\"name\":\"tamari\"},{\"id\":887,\"name\":\"tapioca flour\"},{\"id\":888,\"name\":\"tarragon\"},{\"id\":889,\"name\":\"tart apple\"},{\"id\":890,\"name\":\"tea bags\"},{\"id\":891,\"name\":\"tequila\"},{\"id\":892,\"name\":\"teriyaki sauce\"},{\"id\":893,\"name\":\"thai basil\"},{\"id\":894,\"name\":\"thai chiles\"},{\"id\":895,\"name\":\"thai red curry paste\"},{\"id\":896,\"name\":\"thick-cut bacon\"},{\"id\":897,\"name\":\"tilapia fillets\"},{\"id\":898,\"name\":\"toast\"},{\"id\":899,\"name\":\"toffee bits\"},{\"id\":900,\"name\":\"tofu\"},{\"id\":901,\"name\":\"tomatillos\"},{\"id\":902,\"name\":\"tomato juice\"},{\"id\":903,\"name\":\"tomato paste\"},{\"id\":904,\"name\":\"tomato puree\"},{\"id\":905,\"name\":\"tomato sauce\"},{\"id\":906,\"name\":\"tomato soup\"},{\"id\":907,\"name\":\"tomatoes\"},{\"id\":908,\"name\":\"top blade steak\"},{\"id\":909,\"name\":\"top round steak\"},{\"id\":910,\"name\":\"Top Sirloin\"},{\"id\":911,\"name\":\"tortilla\"},{\"id\":912,\"name\":\"tortilla chips\"},{\"id\":913,\"name\":\"triple sec\"},{\"id\":914,\"name\":\"truffle oil\"},{\"id\":915,\"name\":\"tuna\"},{\"id\":916,\"name\":\"turbinado sugar\"},{\"id\":917,\"name\":\"turkey\"},{\"id\":918,\"name\":\"turkey breast\"},{\"id\":919,\"name\":\"turkey kielbasa\"},{\"id\":920,\"name\":\"turmeric\"},{\"id\":921,\"name\":\"turnips\"},{\"id\":922,\"name\":\"unbleached flour\"},{\"id\":923,\"name\":\"unsalted butter\"},{\"id\":924,\"name\":\"unsmoked back bacon\"},{\"id\":925,\"name\":\"unsweetened applesauce\"},{\"id\":926,\"name\":\"unsweetened coconut milk\"},{\"id\":927,\"name\":\"unsweetened shredded coconut\"},{\"id\":928,\"name\":\"vanilla bean\"},{\"id\":929,\"name\":\"vanilla bean paste\"},{\"id\":930,\"name\":\"vanilla essence\"},{\"id\":931,\"name\":\"vanilla extract\"},{\"id\":932,\"name\":\"vanilla frosting\"},{\"id\":933,\"name\":\"vanilla instant pudding mix\"},{\"id\":934,\"name\":\"vanilla protein powder\"},{\"id\":935,\"name\":\"vanilla wafers\"},{\"id\":936,\"name\":\"vanilla yogurt\"},{\"id\":937,\"name\":\"vegan cheese\"},{\"id\":938,\"name\":\"vegan chocolate chips\"},{\"id\":939,\"name\":\"vegan margarine\"},{\"id\":940,\"name\":\"vegetable broth\"},{\"id\":941,\"name\":\"vegetable oil\"},{\"id\":942,\"name\":\"vegetarian bacon\"},{\"id\":943,\"name\":\"vermouth\"},{\"id\":944,\"name\":\"vinaigrette\"},{\"id\":945,\"name\":\"vinegar\"},{\"id\":946,\"name\":\"vodka\"},{\"id\":947,\"name\":\"walnuts\"},{\"id\":948,\"name\":\"water\"},{\"id\":949,\"name\":\"water chestnuts\"},{\"id\":950,\"name\":\"water-packed tuna\"},{\"id\":951,\"name\":\"watercress\"},{\"id\":952,\"name\":\"watermelon chunks\"},{\"id\":953,\"name\":\"wheat bran\"},{\"id\":954,\"name\":\"wheat germ\"},{\"id\":955,\"name\":\"whipped cream\"},{\"id\":956,\"name\":\"whipped topping\"},{\"id\":957,\"name\":\"whipping cream\"},{\"id\":958,\"name\":\"whiskey\"},{\"id\":959,\"name\":\"white balsamic vinegar\"},{\"id\":960,\"name\":\"white bread\"},{\"id\":961,\"name\":\"white cake mix\"},{\"id\":962,\"name\":\"white cheddar\"},{\"id\":963,\"name\":\"white chocolate\"},{\"id\":964,\"name\":\"white chocolate chips\"},{\"id\":965,\"name\":\"white onion\"},{\"id\":966,\"name\":\"white pepper\"},{\"id\":967,\"name\":\"white whole wheat flour\"},{\"id\":968,\"name\":\"white wine\"},{\"id\":969,\"name\":\"white wine vinegar\"},{\"id\":970,\"name\":\"whole allspice berries\"},{\"id\":971,\"name\":\"whole chicken\"},{\"id\":972,\"name\":\"whole coriander seeds\"},{\"id\":973,\"name\":\"whole cranberry sauce\"},{\"id\":974,\"name\":\"whole kernel corn\"},{\"id\":975,\"name\":\"whole star anise\"},{\"id\":976,\"name\":\"whole wheat bread\"},{\"id\":977,\"name\":\"whole wheat flour\"},{\"id\":978,\"name\":\"whole wheat tortillas\"},{\"id\":979,\"name\":\"whole-grain mustard\"},{\"id\":980,\"name\":\"wine\"},{\"id\":981,\"name\":\"wine vinegar\"},{\"id\":982,\"name\":\"winter squash\"},{\"id\":983,\"name\":\"won ton wraps\"},{\"id\":984,\"name\":\"worcestershire sauce\"},{\"id\":985,\"name\":\"wraps\"},{\"id\":986,\"name\":\"xanthan gum\"},{\"id\":987,\"name\":\"yeast\"},{\"id\":988,\"name\":\"yellow bell pepper\"},{\"id\":989,\"name\":\"yellow cake mix\"},{\"id\":990,\"name\":\"yellow onion\"},{\"id\":991,\"name\":\"yogurt\"},{\"id\":992,\"name\":\"yukon gold potato\"}]";;
//  var data = jsonDecode(json);
//  for(Map<String, dynamic> ingredient in data) {
//    ingredientList.add(ingredient['name']);
//  }

    return ingredientList;
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    int counter = 0;
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query) && counter < 6) {
          dummyListData.add(item);
          counter++;
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        //items.add('No Items Match Inputted Ingredient');
        //items.addAll(duplicateItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text('Navbar'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Input an Ingredient",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.camera),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
            ),
            Row (
              children:<Widget>[
                new Container(
                  width: 10.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Vegetarian');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration (
//                      border: Border(
//                        top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                        left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                        right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
//                        bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
//                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: const Text(
                        'Vegetarian',
                        style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                new Container(
                  width: 25.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Vegan');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                        ' Vegan ',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
                new Container(
                  width: 25.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Low Calorie');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                        'Low Calorie',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
              ],
            ),
            // cuisine, diet, alergens, ingredients,
            new Divider(
              color: Colors.grey,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return new Container(
                      child: new ListTile(
                          title: new Text('${items[index]}'),
                        trailing: Icon(Icons.add_circle),
                        onTap: () {
                      _onSearchButtonPressed('${items[index]}');
                      showDialog(context: context, child:
                      new AlertDialog(
                        title: new Text("Ingredient Added:"),
                        content: new Text("${items[index]}"),
                      )
                      );
                    },
                      ),
                      decoration:
                      new BoxDecoration(
                          border: new Border(
                              bottom: new BorderSide()
                          )
                      )
                  );
//                  return ListTile(
//                    title: Text('${items[index]}'),
//                    trailing: Icon(Icons.add_circle),
//                    onTap: () {
//                      _onSearchButtonPressed('${items[index]}');
//                      showDialog(context: context, child:
//                      new AlertDialog(
//                        title: new Text("Ingredient Added:"),
//                        content: new Text("${items[index]}"),
//                      )
//                      );
//                    },
//                  );a
                },
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.navigate_next),
                elevation: 0,
                onPressed: () => {},
              ),
            ),
          ],
        ),

      ),
    );
  }
  void _onSearchButtonPressed(String keyWord) {
    wordsToSend.add(keyWord);
    print('LIST BEING RETURNED');
    for (int i =0; i < wordsToSend.length; i++) {
      print(wordsToSend[i]);
    }
    print('FINAL LIST');
  }
}
