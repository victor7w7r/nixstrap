{ lib, ... }:
{
  den.default.provides.to-users.homeManager.programs =
    let
      lolquotes = ''
        case $((RANDOM % 90)) in
          0) echo "El amor por el teléfono ~~" ;;
          1) echo "Van dos en una moto y se cae el del medio jaja xddxd" ;;
          2) echo "A ver cuánto es 3+2?" ;;
          3) echo "Jesse, tú no eres Jesse y Joy" ;;
          4) echo "Alto mi pana, INPECCIÓN DE PENES" ;;
          5) echo "TOP personajes con poses god, #1: tu mamá en 4" ;;
          6) echo "Quieres volverte princesa? Déjame besarte el sapo" ;;
          7) echo "Fui a alcohólicos anónimos y ninguno anónimo, puro compa" ;;
          8) echo "QUÉ ABOGADO" ;;
          9) echo "hoy me siento romántico xddxd" ;;
          10) echo "awa de uwu con un poco de owo" ;;
          11) echo "Marcelo, agacháte y conocelo (un beatbox bien demencial acá :v)" ;;
          12) echo "PORONGA xddxd" ;;
          13) echo "Un hombre soltero después de los 30 ser como (Padrastro, Soltero para Siempre, GORDAS)" ;;
          14) echo "WHEN HACES TUS MOMOS EN VIDEOS" ;;
          15) echo "'Torturan a esposa haciéndola ver One Piece' -- CULTURA OTAKU" ;;
          16) echo "12 + 1 ????????, mueve respondiendo gil" ;;
          17) echo "Al fin, some fucking frio" ;;
          18) echo "Descansa, duerme ya, O MI PUÑO PROBARAS" ;;
          19) echo "Pasen contenido audiovisual de la reproducción humana" ;;
          20) echo "Pasa pasa ig de la minita" ;;
          21) echo "Estoy triste, pase su tarjeta de crédito" ;;
          22) echo "Mujer en el equipo GG" ;;
          23) echo "TUMBA LA CASA MAMI" ;;
          24) echo "Cuidado que pusieron MAMARRRE" ;;
          25) echo "ERI GEY??" ;;
          26) echo "HOY VOY A CONVERTIRME EN TORAX" ;;
          27) echo "Si WhatsApp es tan bueno, por qué no hay WhatsApp 2" ;;
          28) echo "CMEN" ;;
          29) echo "CUM" ;;
          30) echo "MI VIEJA DON PENDEJO" ;;
          31) echo "CAGASTE" ;;
          32) echo "Pensé en algo más gracioso que 24" ;;
          33) echo "Tu papá usa GarchaLife xdddxd" ;;
          34) echo "Quieres un chiste opresor... Porno" ;;
          35) echo "Feliz CUM" ;;
          36) echo "La palabra amigos al revés es sogima que significa amigos pero al revés" ;;
          37) echo "TU VIEJA COME PLASTILINA" ;;
          38) echo "BOMBARDEEEN PERÚ" ;;
          39) echo "Un león siempre cuida de su leono" ;;
          40) echo "Eso diría un maricón" ;;
          41) echo "Pruébame ESTA" ;;
          42) echo "Tu mamá es travesti" ;;
          43) echo "Que quieres que haga, te aplaudo o k" ;;
          44) echo "pongan a dady yanki" ;;
          45) echo "No llores joto" ;;
          46) echo "uele a perra" ;;
          47) echo "Huele a obo :v" ;;
          48) echo "Te mandó saludos Estefi v:" ;;
          50) echo "SOPA DU MACACO, UMA DELIZIA" ;;
          51) echo "PASEN TETAS" ;;
          52) echo "PINCHES N" ;;
          53) echo "Despídete bien" ;;
          54) echo "Raza, alguien sabe como dormir 8 hrs en 4hrs :'v, (Duerme en dos camas :v)" ;;
          55) echo "Por eso no le dan internet a los indigenas xddxd" ;;
          56) echo "8x8 AGARRAME EL CHOCHO JAJASJJAJASSJA CHISTOSO" ;;
          57) echo "NO GRACIAS YO SI TENGO PAPÁ" ;;
          58) echo "LEVANTO FIERROS, POR QUE CULOS NINGUNO" ;;
          59) echo "TU MAMÁ ES MI CARDIO" ;;
          60) echo "Nadie: Niñas al cumplir 13,14 o 15 años (BUSCANDO WEBO xdddxd)" ;;
          61) echo "Los prietos no lloran ... " ;;
          62) echo "La cara de la cariñosa cuando le empiezo a explicarle las 4 libertades esenciales del software libre" ;;
          63) echo "SEXISMO: Miedo a tener sexo" ;;
          64) echo "Cierra el putísimo culo xddxd" ;;
          65) echo "PINCHES PUTOS PENDEJOS, PENDEJOS PUTOS IDIOTAS PENDEJOS" ;;
          66) echo "Ilustración digital hilarante con toques sarcásticos, irónicos y satíricos, que reflejan claramente un contexto el cual no se debe tomar en serio, ya que es solo una representación gráfica de un chiste" ;;
          67) echo "El increíble mundo del SIDA xddxd" ;;
          68) echo "* c sonrroja y gime *" ;;
          69) echo "Encontraron el CP!!!! :vvvVv" ;;
          70) echo "N___A: NINJA NINJA" ;;
          71) echo "MMMM A VER TU MOMO" ;;
          72) echo "AH, NO LE SABES, NO LE SABES AL CHITPOS" ;;
          73) echo "HAGANLE UN CHEEMS, UN MOMICHI, UN GLOBO DE TEXTO, UN CURICERDO, UN SOUL, UN WOJAK, UN PACMAN, UN MIGUEL, UN EDIT DE JOJOS, DIGANLE GROSERIAS, INSULTOS, QUE NO LE SABE, PONGALE UN TRAJE DE MONA CHINA, FUNENLO, DIGANLE SIMP Y SAQUENLO" ;;
          74) echo "hora de ver momos A ver el tuyo" ;;
          75) echo "FUERA ESPÍRITU HOMOSEXUAL" ;;
          76) echo "QUÉ... que me destierras, ah está bien, no estoy de acuerdo con tus políticas" ;;
          77) echo "Cuando te sientas triste, córtate el pito, ahora sentirás dolor y ya no te sentirás triste" ;;
          78) echo "PREPARATE LA P*TA QUE TE REPARIÓ, POR QUE, LOS VIERNES DE LA JUNGLA SERÁN A TODO OJETE" ;;
          79) echo "PARA VIVIR UNA NOCHE, CON LAS MEJORES P*TAS DE LA ZONA, NO TE LA PUEDES PERDER HIJO DE REMIL, POR QUE SI NO ESTÁS AHÍ, ANDATE A LA CONCHA DE LA LORA" ;;
          80) echo "Yo no konfio ni enmi sombra pq es negra" ;;
          81) echo "LAS TETAS SOLO SON NALGAS CON PEZONES" ;;
          82) echo "QUE TE PASE EL DIA" ;;
          83) echo "la paja es sexo light" ;;
          84) echo "soy una persona EXITOSA por que cada vez que te veo ME EXCITO" ;;
          85) echo "Dejaron la CocaCola mal tapada y se le fue el gas ... :c" ;;
          86) echo "Y así, Dios dijo Que.....so JASJAJSAJ QUE CHISTOSO PERO RIETE PUTO" ;;
          87) echo "Pake tener autoestima si puedo tener un auto encima" ;;
          88) echo "Soy como un reloj, me adapto a cualquier muñeca" ;;
          89) echo "Casi conecto el internet" ;;
          90) echo "Suban la dificultad a los bots :v" ;;
          91) echo "UN ENEMIGO DEL FORTNITE" ;;
          92) echo "como tan mushasho" ;;
          93) echo "es k el sans dijo: EEEEE E E EEE E E E EEEEEE E E E E EE" ;;
          94) echo "picadura de la cobra gey" ;;

        esac
      '';
      random-quote = ''
        if ! command -v fortune &>/dev/null; then
          case $(((RANDOM % 1) + 1)) in
          1) lolquotes ;;
          2) bofh ;;
          esac
        else
          case $(((RANDOM % 2) + 1)) in
          1) lolquotes ;;
          2) fortune ;;
          3) bofh ;;
          esac
        fi
      '';
    in
    {
      zsh.siteFunctions = {
        inherit lolquotes random-quote;
      };
      bash.bashrcExtra = (
        lib.mkOrder 750 ''
          lolquotes() {
            ${lolquotes}
          }

          random-quote() {
            ${random-quote}
          }
        ''
      );
    };
}
