using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class KorisnikUI : IKorisnikUI
    {
        private readonly IKorisnikBL _IKorisnikBL;
        private readonly IReportUI _IReportUI;
        private readonly IReportKomentaraUI _IReportKomentaraUI;
        private readonly IDislajkoviUI _IDislajkoviUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
     


        public KorisnikUI(IKorisnikBL IKorisnikBL, IReportUI IReportUI, IDislajkoviUI IDislajkoviUI, IGradKorisniciUI IGradKorisniciUI, IReportKomentaraUI IReportKomentaraUI)
        {
            _IKorisnikBL = IKorisnikBL;
            _IReportUI = IReportUI;
            _IDislajkoviUI = IDislajkoviUI;
            _IGradKorisniciUI = IGradKorisniciUI;
            _IReportKomentaraUI = IReportKomentaraUI;
        }

          public int deleteKorisnikaByAdmin(long idKorisnik,String token)
        {
            return _IKorisnikBL.deleteKorisnikaByAdmin(idKorisnik,token);
        }


         public void deleteKorisnikaById(PrihvatanjeIdKorisnika korisnika,String token)
        {
            _IKorisnikBL.deleteKorisnikaById(korisnika.idKorisnika,token);
            
        }

        public Korisnik dodajProfilnuSlikuKorisniku(PrihvatanjeIdKorisnika korisnik)
        {
            return _IKorisnikBL.dodajProfilnuSlikuKorisniku(korisnik.idKorisnika);
        }

        public List<Korisnik> getAllKorisnik()
        {
            return _IKorisnikBL.getAllKorisnik();
        }

        public List<KorisnikSaGradovima> getAllKorisnikGrad()
        {
            return _IKorisnikBL.getAllKorisnikGrad();
        }

        public Korisnik getKorisnikaById(long idKorisnika)
        {
            return _IKorisnikBL.getKorisnikaById(idKorisnika);
        }

        public List<KorisnikSaGradovima> getKorisnikByFilter(string data)
        {
            var korisnici = _IKorisnikBL.getKorisnikByFilter(data);
            if (korisnici == null) return null;
            var listaKorisnika = new List<KorisnikSaGradovima>();
            foreach (var korisnik in korisnici)
            {
                var vlasnik = _IKorisnikBL.convertKorisnika(korisnik);
                vlasnik.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                if (vlasnik != null)
                {
                    listaKorisnika.Add(vlasnik);
                }

            }
            return listaKorisnika;
        }

         public int izmeniPodatke(AzuriranjeKorisnika data,String token)
        {
            return _IKorisnikBL.izmeniPodatke(data,token);
        }

        public KorisnikSaGradovima LoginCheck(Korisnik k)
        {
            return _IKorisnikBL.LoginCheck(k);
        }

          public Korisnik odjavaKorisnika(PrihvatanjeIdKorisnika korisnik,String token)
        {
            return _IKorisnikBL.odjavaKorisnika(korisnik.idKorisnika,token);
        }


        public KorisnikSaGradovima posaljiKorisnika(long idKorisnika)
        {
            var korisnik = _IKorisnikBL.getKorisnikaById(idKorisnika);
            if (korisnik == null) return null;
            var convert = _IKorisnikBL.convertKorisnika(korisnik);
            var gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(idKorisnika);
            convert.gradovi = gradovi;
            return convert;
        }

        public Korisnik postaviAdmina(PrihvatanjeIdKorisnika admin)
        {
            return _IKorisnikBL.postaviAdmina(admin.idKorisnika);
        }

        /*   public List<Korisnik> pretragaKorisnikZaAdmina(PretragaKorisnika korisnik)
           {
               List<Korisnik> listaKorisnika = new List<Korisnik>();
               if (korisnik.filter != null)
               {
                   listaKorisnika = _IKorisnikBL.getKorisnikByFilter(korisnik.filter);
               }
               else listaKorisnika = _IKorisnikBL.getAllKorisnik();
               if (korisnik.objava != null)
               {
                   PrihvatanjeIdKorisnika kor = new PrihvatanjeIdKorisnika();
                   kor.idGrada = korisnik.idGrada;
                   kor.odBroja = korisnik.odBrojaObjava;
                   kor.doBroja = korisnik.doBrojaObjava;

                  listaKorisnika = this.vratiKorisnikeByReportaObjava(kor,listaKorisnika);


               }
               if (korisnik.komentar != null)
               {
                   PrihvatanjeIdKorisnika kor = new PrihvatanjeIdKorisnika();
                   kor.idGrada = korisnik.idGrada;
                   kor.odBroja = korisnik.odBrojaKomentara;
                   kor.doBroja = korisnik.doBrojaKomentara;
                   listaKorisnika = this.vratiKorisnikeByReportaKomentara(kor,listaKorisnika);

               }
               if (korisnik.komentar ==  null && korisnik.objava == null)
               {
                   var lista = new List<long>();
                   if (korisnik.idGrada == 0)
                   {
                       var pomLista = _IKorisnikBL.getAllKorisnik();
                       lista = pomLista.Select(k => k.id).ToList();
                   }
                   else lista = _IGradKorisniciUI.getKorinsikeByIdGrada(korisnik.idGrada);
                   var korisnci = new List<Korisnik>();
                   foreach(var id in lista)
                   {
                       var kor = _IKorisnikBL.getKorisnikaById(id);
                       korisnci.Add(kor);
                   }

                       listaKorisnika = listaKorisnika.Intersect(korisnci).ToList();

               }

               return listaKorisnika;
           }
           */
        public List<KorisnikZaAdmina> pretragaKorisnikZaAdmina(PretragaKorisnika korisnik)
        {
            List<Korisnik> listaKorisnika = new List<Korisnik>();
            if (korisnik.filter != null)
            {
                listaKorisnika = _IKorisnikBL.getKorisnikByFilter(korisnik.filter);
            }
            else listaKorisnika = _IKorisnikBL.getAllKorisnik();
            var pomLista = new List<Korisnik>();
            if (korisnik.idGrada == 0)
            {
                 pomLista = _IKorisnikBL.getAllKorisnik();
              
            }
            else pomLista = _IGradKorisniciUI.getListuKorinsikaByIdGrada(korisnik.idGrada);
           

            listaKorisnika = listaKorisnika.Intersect(pomLista).ToList();
            List<KorisnikZaAdmina> listaZaAdmina = new List<KorisnikZaAdmina>();

            foreach(var kor in listaKorisnika)
            {
                var korisnikZaAdmina = this.convertUKorisnikZaAdmina(kor);
                korisnikZaAdmina.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(kor.id);
                listaZaAdmina.Add(korisnikZaAdmina);
               
            }
            
            return listaZaAdmina.OrderByDescending(l => l.poeni).ToList();
        }

        private KorisnikZaAdmina convertUKorisnikZaAdmina(Korisnik k)
        {
            KorisnikZaAdmina korisnika = new KorisnikZaAdmina();
            korisnika.id = k.id;
            korisnika.ime = k.ime;
            korisnika.Token = k.Token;
            korisnika.ime = k.ime;
            korisnika.prezime = k.prezime;
            korisnika.username = k.username;
            korisnika.poeni = k.poeni;
            korisnika.uloga = k.uloga;
            korisnika.ocenaAplikacije = k.ocenaAplikacije;
            korisnika.brojUkupnih = korisnika.brojNeresenih + korisnika.brojResenih;
            korisnika.brojPrijavljenihObjava = _IReportUI.brojReportovaZaVlasnikaObjava(k.id);
            korisnika.brojPrijavljenihKomentara = _IReportKomentaraUI.brojReportovaZaVlasnikaKomentara(k.id);
            return korisnika;

        }

        // public List<long> prikaziKorisnikaZaAdmina(long odBroja=0, long doBroja=100)
        public List<long> prikaziKorisnikaZaAdmina(long odBroja, long doBroja, String trazi,List<Korisnik> korisnici)
        {
            // List<Korisnik> korisnici = new List<Korisnik>();
            if (korisnici == null)
            {
                korisnici = _IKorisnikBL.getAllKorisnik();
            }
            List<Korisnik> listaKorisnika = new List<Korisnik>();
            if (trazi == "objava")
            {
                foreach (var korisnik in korisnici)
                {
                    var brojReportovaniObjava = _IReportUI.brojReportovaZaVlasnikaObjava(korisnik.id);
                    if (brojReportovaniObjava >= odBroja && brojReportovaniObjava <= doBroja)
                    {
                        listaKorisnika.Add(korisnik);
                    }
                }
            }
            if (trazi == "komentar")
            {
                foreach (var korisnik in korisnici)
                {
                    var brojReportovaniKomentara = _IReportKomentaraUI.brojReportovaZaVlasnikaKomentara(korisnik.id);
                    if (brojReportovaniKomentara >= odBroja && brojReportovaniKomentara <= doBroja)
                    {
                        listaKorisnika.Add(korisnik);
                    }
                }
            }
            
               return listaKorisnika.Select(k => k.id).ToList();
        }

        public Korisnik  saveKorisnik(Korisnik data)
        {
             return _IKorisnikBL.saveKorisnik(data);
        }

        public void saveProfilImage(PrihvatanjeSlike slika,String token)
        {
            _IKorisnikBL.saveProfilImage(slika,token);
        }

        private List<Korisnik> vratiKorisnikeByReportaKomentara(PrihvatanjeIdKorisnika korisnik,List<Korisnik> korisnici)
        {
            List<long> lista1;
            if (korisnik.idGrada == 0)
            {
                var pomLista = _IKorisnikBL.getAllKorisnik();
                lista1 = pomLista.Select(k => k.id).ToList();
            }
            else
            {
                lista1 = _IGradKorisniciUI.getKorinsikeByIdGrada(korisnik.idGrada);
            }
            String komentar = "komentar";
            List<long> lista2 = this.prikaziKorisnikaZaAdmina(korisnik.odBroja, korisnik.doBroja,komentar,korisnici);
            var listaIdKorisnika = lista1.Intersect(lista2);
            var listaKorisnika = new List<Korisnik>();
            foreach (var id in listaIdKorisnika)
            {

                var kor = _IKorisnikBL.getKorisnikaById(id);
                listaKorisnika.Add(kor);
            }

            return listaKorisnika;

        }
        public long proveraKorisnika(Korisnik korisnik)
        {
            return _IKorisnikBL.proveraKorisnika(korisnik);
        }
        private List<Korisnik> vratiKorisnikeByReportaObjava(PrihvatanjeIdKorisnika korisnik,List<Korisnik> korisnici)
        {
            List<long> lista1;
            if (korisnik.idGrada == 0)
            {
                var pomLista = _IKorisnikBL.getAllKorisnik();
                lista1 = pomLista.Select(k => k.id).ToList();
            }
            else
            {
                lista1 = _IGradKorisniciUI.getKorinsikeByIdGrada(korisnik.idGrada);
            }
            String objava = "objava";
           List<long> lista2 = this.prikaziKorisnikaZaAdmina(korisnik.odBroja, korisnik.doBroja,objava,korisnici);
           var listaIdKorisnika = lista1.Intersect(lista2);
           var listaKorisnika = new List<Korisnik>();
           foreach (var id in listaIdKorisnika)
           {

               var kor = _IKorisnikBL.getKorisnikaById(id);
               listaKorisnika.Add(kor);
           }

            return listaKorisnika;
        }

        public OcenaAplikacije ocenaAplikacije()
        {
            return  _IKorisnikBL.ocenaAplikacije();
        }

        public List<Korisnik> top10PoPoenima()
        {
            return _IKorisnikBL.top10PoPoenima();
        }

        public void oduzmiPoeneKorisniku(PrihvatanjePoena poeni)
        {
            _IKorisnikBL.oduzmiPoeneKorisniku(poeni);
        }

        public void dodajPoeneKorisniku(PrihvatanjePoena poeni)
        {
            _IKorisnikBL.dodajPoeneKorisniku(poeni);
        }

        public List<Boje> getBoje()
        {
            return _IKorisnikBL.getBoje();
        }
        public Boje getBojeById(long idBoje)
        {
            return _IKorisnikBL.getBojeById(idBoje);
        }
        public KorisnikSaGradovima convertKorisnika(Korisnik k)
        {
            return _IKorisnikBL.convertKorisnika(k);
        }

        public int proveraKoda(PrihvatanjeKoda data)
        {
            return _IKorisnikBL.proveraKoda(data);
        }
        public Gejmifikacija getBojeZaKorisnika(PrihvatanjeIdKorisnika idKorisnika)
        {
            Gejmifikacija gejmifikacija = new Gejmifikacija();
            gejmifikacija.boje = getBoje();
            var korisnik = _IKorisnikBL.getKorisnikaById(idKorisnika.idKorisnika);
            if (korisnik.poeni < 10) gejmifikacija.bojaKorisnika = _IKorisnikBL.getBojeById(1);
            gejmifikacija.bojaKorisnika = _IKorisnikBL.getBojeById((korisnik.poeni / 10) + 1);
            gejmifikacija.poeniDoSledeceBoje = 10 - (korisnik.poeni % 10);
            return gejmifikacija;
        }

        public void zaboravljenaSifra(ZaboravljenaSifra data)
        {
            _IKorisnikBL.zaboravljenaSifra(data);
        }

        public Korisnik vratiUloguKorisnika(long idKorisnika)
        {
            return _IKorisnikBL.vratiUloguKorisnika(idKorisnika);
        }

        public void dodajOcenu(PrihvatanjeIdKorisnika korisnik)
        {
            _IKorisnikBL.dodajOcenu(korisnik);
        }
    }
}
