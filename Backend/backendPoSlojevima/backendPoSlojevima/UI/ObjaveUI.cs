using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.UI
{
    public class ObjaveUI : IObjaveUI
    {
        private readonly IObjaveBL _IObjaveBL;
        private readonly ITekstualneObjaveUI _ITekstualneObjaveUI;
        private readonly ISlikeUI _ISlikeUI;
        private readonly IKorisnikUI _IKorisnikUI;
        private readonly ILajkoviUI _ILajkoviUI;
        private readonly IDislajkoviUI _IDislajkoviUI;
        private readonly IKomentariUI _IKomentariUI;
        private readonly IReportUI _IReportUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;
        private readonly IInstitucijeUI _IInstitucijeUI;
        private readonly IKategorijeProblemaUI _IKategorijaProblemaUI;
        private readonly IObjaveKategorijeUI _IObjaveKategorijeUI;
        private readonly IInstitucijeKategorijeUI _IInstitucijeKategorijeUI;


        public ObjaveUI(IInstitucijeKategorijeUI IInstitucijeKategorijeUI, IObjaveKategorijeUI IObjaveKategorijeUI, IKategorijeProblemaUI IKategorijaProblemaUI,IInstitucijeUI IInstitucijeUI, IGradKorisniciUI IGradKorisniciUI,IObjaveBL IObjaveBL, IReportUI IReportUI, ITekstualneObjaveUI ITekstualneObjaveUI, ISlikeUI ISlikeUI, IKorisnikUI IKorisnikUI, ILajkoviUI ILajkoviUI, IDislajkoviUI IDislajkoviUI, IKomentariUI IKomentariUI)
        {

            _IObjaveBL = IObjaveBL;
            _IKategorijaProblemaUI = IKategorijaProblemaUI;
            _ITekstualneObjaveUI = ITekstualneObjaveUI;
            _ISlikeUI = ISlikeUI;
            _IKorisnikUI = IKorisnikUI;
            _ILajkoviUI = ILajkoviUI;
            _IDislajkoviUI = IDislajkoviUI;
            _IKomentariUI = IKomentariUI;
            _IReportUI = IReportUI;
            _IGradKorisniciUI = IGradKorisniciUI;
            _IInstitucijeUI = IInstitucijeUI;
            _IInstitucijeKategorijeUI = IInstitucijeKategorijeUI;
            _IObjaveKategorijeUI = IObjaveKategorijeUI;
        }
        public List<Objave> getAllObjave()
        {
            return _IObjaveBL.getAllObjave();
        }

        public Korisnik getIdKorisnikaByIdObjave(PrihvatanjeIdObjave objava)
        {
            long idKorisnika = _IObjaveBL.getIdKorisnikaByIdObjave(objava.idObjave);
            Korisnik korisnik = _IKorisnikUI.getKorisnikaById(idKorisnika);
            return korisnik;
        }

        public void saveObjavu(PrihvatanjeObjave objava)
        {
            _IObjaveBL.saveObjavu(objava);
        }

        public SveObjave izlistajSveZaObjavu(Objave objava, long aktivanKorisnik)
        {
            SveObjave spakuj = new SveObjave();
            if (objava.LepaStvarID != 0)
            {
                spakuj.lepaStvar = _IObjaveBL.getLepeStavriById(objava.LepaStvarID);
                spakuj.kategorije = null;
            }
            else
            {
                spakuj.lepaStvar = null;
                spakuj.kategorije = _IObjaveKategorijeUI.getKategorijeByIdObjave(objava.id);
            }
            if (objava.idTipa == 2)
            {
                var tekst_objava = _ITekstualneObjaveUI.getTekstualnaObjavaByObjavaId(objava.id);
                spakuj.tekstualna_objava = tekst_objava;
                spakuj.slika = null;
            }
            else
            {
                var slika = _ISlikeUI.getSlikuByIdObjave(objava.id);
                spakuj.tekstualna_objava = null;
                spakuj.slika = slika;

            }
            var korisnik = _IKorisnikUI.getKorisnikaById(objava.KorisnikID);
            var vlasnikObjave = _IKorisnikUI.convertKorisnika(korisnik);
            vlasnikObjave.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
            spakuj.vlasnikObjave = vlasnikObjave;
            spakuj.idObjave = objava.id;
            PrihvatanjeIdObjave data = new PrihvatanjeIdObjave();
            data.idObjave = objava.id;

            spakuj.brojLajkova = _ILajkoviUI.getBrojLajkovaByIdObjave(data);
            spakuj.brojDislajkova = _IDislajkoviUI.getBrojDislajkovaByIdObjave(data);
            spakuj.brojKomentara = _IKomentariUI.getBrojKomentaraByIdObjave(data);
            spakuj.brojReporta = _IReportUI.dajSveReportoveByIdObjave(data);
            spakuj.resenaObjava = objava.resenaObjava;
            spakuj.vreme = objava.vreme;
            var datum = objava.vreme;
            spakuj.vreme2 = datum.ToString("dd.M.yyyy H:mm");
           
            proveriAktivnost(aktivanKorisnik, spakuj, objava);

            return spakuj;
        }


        public List<SveObjave> izlistajSveObjave(IEnumerable<Objave> objave,long aktivanKorisnik)
        {
            List<SveObjave> sveObjave = new List<SveObjave>();
            foreach (var objava in objave)
            {
                SveObjave spakuj = new SveObjave();
                if (objava.LepaStvarID != 0)
                {
                    spakuj.lepaStvar = _IObjaveBL.getLepeStavriById(objava.LepaStvarID);
                    spakuj.kategorije = null;
                }
                else
                {
                    spakuj.lepaStvar = null;
                  //  spakuj.kategorije = new List<KategorijeProblema>();
                    spakuj.kategorije = _IObjaveKategorijeUI.getKategorijeByIdObjave(objava.id);
                }
                if (objava.idTipa == 2)
                {
                    var tekst_objava = _ITekstualneObjaveUI.getTekstualnaObjavaByObjavaId(objava.id);
                    spakuj.tekstualna_objava = tekst_objava;
                    spakuj.slika = null;
                }
                else
                {
                    var slika = _ISlikeUI.getSlikuByIdObjave(objava.id);
                    spakuj.tekstualna_objava = null;
                    spakuj.slika = slika;

                }
                var  korisnik = _IKorisnikUI.getKorisnikaById(objava.KorisnikID);
                var vlasnikObjave = _IKorisnikUI.convertKorisnika(korisnik);
                vlasnikObjave.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                spakuj.vlasnikObjave = vlasnikObjave;
                spakuj.idObjave = objava.id;
                PrihvatanjeIdObjave data = new PrihvatanjeIdObjave();
                data.idObjave = objava.id;
         
                spakuj.brojLajkova = _ILajkoviUI.getBrojLajkovaByIdObjave(data);
                spakuj.brojDislajkova = _IDislajkoviUI.getBrojDislajkovaByIdObjave(data);
                spakuj.brojKomentara = _IKomentariUI.getBrojKomentaraByIdObjave(data);
                spakuj.brojReporta = _IReportUI.dajSveReportoveByIdObjave(data);
                spakuj.resenaObjava = objava.resenaObjava;
                spakuj.vreme = objava.vreme;
                var datum = objava.vreme;
             //   var napraviDatum = String.Format("{0:g}", datum);
                spakuj.vreme2 = datum.ToString("dd.M.yyyy H:mm");
                /*
                spakuj.datum = new DateTime("{0:d}", objava.vreme);
                spakuj.satImi String.Format("{0:g}", objave.vreme);*/

                // spakuj.komentari = _IKomentariUI.sveZaKomentare(data);
               
                if (aktivanKorisnik != 0) proveriAktivnost(aktivanKorisnik, spakuj, objava);
                if (spakuj != null)
                {
                    sveObjave.Add(spakuj);
                }
                
            }
            sveObjave.OrderByDescending(o => o.vreme);
            return sveObjave;
        }

        private void proveriAktivnost(long idKorisnika, SveObjave spakuj, Objave objava)
        {
            spakuj.aktivanKorisnikLajkovao = _ILajkoviUI.getLajkByKorisnikId(idKorisnika,objava.id);
            spakuj.aktivanKorisnikDislajkovao = _IDislajkoviUI.getDislajkByKorisnikId(idKorisnika, objava.id);
            spakuj.aktivanKorisnikReport = _IReportUI.getReportByKorisnikId(idKorisnika, objava.id);
            
        }
        public List<SveObjave> vratiSveObjave(PrihvatanjeIdKorisnika aktivanKorisnik)
        {
           List<long> nizGradova = _IGradKorisniciUI.getGradoveByIdKorisnika(aktivanKorisnik.idKorisnika);
            IEnumerable<Objave> objave = _IObjaveBL.getObjaveByIdGradova(nizGradova);
            var lista = izlistajSveObjave(objave,aktivanKorisnik.idKorisnika).OrderByDescending(o => o.vreme).ToList();
            return lista;
            
        }

        public List<SveObjave> dajSveObjaveByIdKorisnika(PrihvatanjeIdKorisnika data)
        {

            IEnumerable<Objave> objave = this.getObjaveByIdKorisnika(data);
            return izlistajSveObjave(objave,data.idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public SveZaObjavu dajSveZaObjavu(PrihvatanjeIdObjave data)
        {
            SveZaObjavu objava = new SveZaObjavu();
              objava.idObjave = data.idObjave;
              objava.brojLajkova = _ILajkoviUI.getBrojLajkovaByIdObjave(data);
              objava.brojDislajkova = _IDislajkoviUI.getBrojDislajkovaByIdObjave(data); 
              objava.brojKomentara = _IKomentariUI.getBrojKomentaraByIdObjave(data);
              objava.brojReporta = _IReportUI.dajSveReportoveByIdObjave(data);
            // objava.komentari = _IKomentariUI.sveZaKomentare(data);
            objava.aktivanKorisnikDislajkova = _IDislajkoviUI.getDislajkByKorisnikId(data.idKorisnika, data.idObjave);
            objava.aktivanKorisnikLajkova= _ILajkoviUI.getLajkByKorisnikId(data.idKorisnika, data.idObjave);
            objava.aktivanKorisnikReportovao= _IReportUI.getReportByKorisnikId(data.idKorisnika, data.idObjave);
            objava.idObjave = data.idObjave;   
            return objava;
        }

        public List<Objave> getObjaveByIdKorisnika(PrihvatanjeIdKorisnika korisnik)
        {
            return _IObjaveBL.getObjaveByIdKorisnika(korisnik.idKorisnika);
        }

        public AktivnostiKorisnika aktivnostiKorisnika(PrihvatanjeIdKorisnika data)
        {
            AktivnostiKorisnika korisnik = new AktivnostiKorisnika();
            korisnik.lajkovi = _ILajkoviUI.getLajkoveByKorisnikId(data);
            korisnik.dislajkovi = _IDislajkoviUI.getDislajkoveByKorisnikId(data);
            korisnik.reportovi = _IReportUI.getReportoveByKoirsnikId(data.idKorisnika);
            korisnik.komentari = _IKomentariUI.getKomentareByKorisnikId(data);

            return korisnik;
            
        }

        public Objave getObjavaByIdObjave(long  idObjave)
        {
            return _IObjaveBL.getObjavaByIdObjave(idObjave);
        }

        public void deleteSveZaObjavuByIdObjave(PrihvatanjeIdObjave objava,int ind)
        {
            /*  var idObjave = objava.idObjave;
              var objava1 = _IObjaveBL.getObjavaByIdObjave(idObjave);
              _ILajkoviUI.deleteLajkoveByIdObjave(idObjave);
              _IDislajkoviUI.deleteDislajkoveByIdObjave(idObjave);
              _IReportUI.deleteReportoveByIdObjave(idObjave);
              _IKomentariUI.deleteKomentareByIdObjave(idObjave);
               _ITekstualneObjaveUI.deleteTekstualnuObjavuByIdObjave(objava);*/
             _ISlikeUI.deleteSlikuByIdObjave(objava.idObjave);
             _IKomentariUI.deleteKomentareByIdObjave(objava.idObjave);
             _IObjaveBL.deleteObjavuByIdObjave(objava.idObjave,ind); //brisemo objavu*/
        }

        public void deleteSveZaObjavuByIdKorisnika(PrihvatanjeIdKorisnika korisnik)
        {
            /* var idKorisnika = korisnik.idKorisnika;
            _ILajkoviUI.deleteLajkoveByIdKorisnika(idKorisnika);
            _IDislajkoviUI.deleteDislajkoveByIdKorisnika(idKorisnika);
            _IReportUI.deleteReportoveByIdKorisnika(idKorisnika);
            _IKomentariUI.deleteKomentareByIdKorisnika(idKorisnika);
            _IObjaveBL.deleteObjavuByIdKorisnika(korisnik.idKorisnika);
            _ITekstualneObjaveUI.deleteTekstualnuObjavuByIdKorisnika(korisnik);*/
            _IKomentariUI.deleteKomentareByIdKorisnika(korisnik.idKorisnika);
            _ISlikeUI.deleteSlikeByIdKorisnika(korisnik.idKorisnika); //brisemo objavu*/
            //OBRISI SLIKE IZ KOMENTARA I OBJAVA IZ FOLDERA

        }

        public Objave problemResen(PrihvatanjeIdObjave objave,long ind)
        {
            var institucija = _IInstitucijeUI.getInstitucijuByIdInsititucije(ind);
            if (institucija == null) ind = 1;
            return _IObjaveBL.problemResen(objave.idObjave,ind);
        }

        public List<SveObjave> prikaziSveReseneObjave(long idKorisnika)
        {
            List<Objave> objave = _IObjaveBL.getReseneObjave();
            return this.izlistajSveObjave(objave,idKorisnika).OrderByDescending(o => o.vreme).ToList();

        }

        public List<SveObjave> vratiSveObjaveZaGradove(PrihvatanjeGradova data)
        {
            List<Objave> objave = _IObjaveBL.getObjaveByIdGradova(data.idGradova);
            return this.izlistajSveObjave(objave,data.idKorisnika).OrderByDescending(o => o.vreme).ToList();

        }

        public List<SveObjave> vratiSveObjaveZaGrad(PrihvatanjeIdGrada grad)
        {
            List<Objave> objave = _IObjaveBL.getObjaveByIdGrada(grad.idGrada);
            return this.izlistajSveObjave(objave,grad.idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> dajReseneProblemeZaInstituiju(PrihvatanjeIdInstitucije institucije)
        {
            List<Objave> listaObjava = _IObjaveBL.getReseneObjaveByIdInstitucije(institucije.idInstitucije);
            return this.izlistajSveObjave(listaObjava,institucije.aktivanKorisnik).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> prikaziSveReseneObjaveZaGradove(PrihvatanjeGradova nizGradova)
        {
            var lista = _IObjaveBL.getReseneObjaveByGradove(nizGradova.idGradova);
            return izlistajSveObjave(lista,nizGradova.idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> prikaziSveNereseneObjaveZaGradove(PrihvatanjeGradova nizGradova)
        {
            var lista = _IObjaveBL.getNereseneObjaveByGradove(nizGradova.idGradova);
            return izlistajSveObjave(lista,nizGradova.idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> prikazNajpopularnijihObjava(PrihvatanjeGradova nizGradova)
        {
            var listaObjava = _IObjaveBL.getObjaveByIdGradova(nizGradova.idGradova);
            var lista = izlistajSveObjave(listaObjava,nizGradova.idKorisnika);
            lista = lista.OrderBy(o => o.brojLajkova).ThenBy(o => o.vreme).ToList();
            lista.Reverse();
            return lista;
        }
        public List<SveObjave> prikazNajnepopularnijihObjava(PrihvatanjeGradova nizGradova)
        {
            var listaObjava = _IObjaveBL.getObjaveByIdGradova(nizGradova.idGradova);
            var lista = izlistajSveObjave(listaObjava,nizGradova.idKorisnika);
            lista = lista.OrderBy(o => o.brojLajkova).ThenByDescending(o=>o.brojDislajkova).ToList();
            return lista;
        }

        public List<SveObjave> prikaziObjaveOdDatuma(PrihvatanjeGradova nizGradova)
        {
            var lista = _IObjaveBL.getObjaveByIdGradova(nizGradova.idGradova);
            var novaLista = lista.Where(l => l.vreme >= nizGradova.vreme).ToList();
            return izlistajSveObjave(novaLista,nizGradova.idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        
      

        public List<SveObjave> prikaziObjaveZaAdministratora(long idGrada)
        {
            IEnumerable<Objave> lista = _IReportUI.getReportovaneObjave();

            if (idGrada == 0)
            {
                return izlistajSveObjave(lista, 0).OrderByDescending(o => o.vreme).ToList();
            }
            else
            {
                var listaGrad = lista.Where(l => l.GradID == idGrada);
                return izlistajSveObjave(listaGrad, 0).OrderByDescending(o => o.vreme).ToList();
            }
            

        }

        public Statistika prikaziStatistikuSvega()
        {
            Statistika statistika = new Statistika();
            statistika.brojResenihProblema = _IObjaveBL.getReseneObjave().Count();
            statistika.brojNeresenihProblema = _IObjaveBL.getNereseneObjave().Count();
            statistika.brojPrijavljenihObjava = _IReportUI.getReportovaneObjave().Count();
            statistika.ukupnanBroj = statistika.brojResenihProblema + statistika.brojNeresenihProblema;
            return statistika;
        }
        
        public List<SveObjave> dajNeReseneProblemeZaInstituiju(long idInstitucije)
        {
            List<long> nizGradova = _IGradKorisniciUI.getGradoveByIdKorisnika(idInstitucije);
            IEnumerable<Objave> objave = _IObjaveBL.getNereseneObjaveByGradove(nizGradova);
            var lista = izlistajSveObjave(objave, idInstitucije).OrderByDescending(o => o.vreme).ToList();
            return lista;
        }
        public List<SveObjave> dajReseneProblemePocetneZaInstituiju(long idInstitucije)
        {
            List<long> nizGradova = _IGradKorisniciUI.getGradoveByIdKorisnika(idInstitucije);
            IEnumerable<Objave> objave = _IObjaveBL.getReseneObjaveByGradove(nizGradova);
            return izlistajSveObjave(objave, idInstitucije);// OrderByDescending(o => o.vreme).ToList();
           
        }

        public List<SveObjave> prikaziSveReseneObjaveZaInstituciju(long idInstitucije)
        {
            List<long> nizGradova = _IGradKorisniciUI.getGradoveByIdKorisnika(idInstitucije);
            IEnumerable<Objave> objave = _IObjaveBL.getReseneObjaveByGradove(nizGradova);
            var lista = izlistajSveObjave(objave, idInstitucije).OrderByDescending(o => o.vreme).ToList();
            return lista;

        }

        public List<SveObjave> getNereseneProblemeByIdKorinsika(long idKorisnika)
        {
            var objava =  _IObjaveBL.getNereseneProblemeByIdKorinsika(idKorisnika);
            return izlistajSveObjave(objava, idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneProblemeByIdKorinsika(long idKorisnika)
        {
            var objava = _IObjaveBL.getReseneProblemeByIdKorinsika(idKorisnika);
            return izlistajSveObjave(objava, idKorisnika).OrderByDescending(o => o.vreme).ToList();
        }

        public List<KorisnikZaAdmina> vratiAdminu(List<KorisnikZaAdmina> lista)
        {
            foreach(var korisnik in lista)
            {
                korisnik.brojNeresenih = _IObjaveBL.getNereseneProblemeByIdKorinsika(korisnik.id).Count();
                korisnik.brojResenih = _IObjaveBL.getReseneProblemeByIdKorinsika(korisnik.id).Count();
            }
            return lista;
        }

        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _IKategorijaProblemaUI.getKategorijeProblema();
        }

        public List<LepeStvari> getLepeStavri()
        {
            return _IObjaveBL.getLepeStavri();
        }

        public List<SveObjave> getNereseneObjaveByGradZa7Dana(long idGrad)
        {
            var objave = _IObjaveBL.getNereseneObjaveByGradZa7Dana(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneObjaveByGradZa7Dana(long idGrad)
        {
            var objave = _IObjaveBL.getReseneObjaveByGradZa7Dana(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();

        }

        public List<SveObjave> getReportovaneObjaveByGrada(long idGrada)
        {
            var objave = _IReportUI.getReportovaneObjaveByIdGrada(idGrada);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReportovaneObjaveByGradaZa7Dana(long idGrada)
        {
            var objave = _IReportUI.getReportovaneObjaveByIdGrada7Dana(idGrada);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReportovaneObjaveByGradaZa30Dana(long idGrada)
        {
            var objave = _IReportUI.getReportovaneObjaveByIdGrada30Dana(idGrada);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }
        public List<SveObjave> getNereseneObjaveByGradZa30Dana(long idGrad)
        {
            var objave = _IObjaveBL.getNereseneObjaveByGradZa30Dana(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneObjaveByGradZa30Dana(long idGrad)
        {
            var objave = _IObjaveBL.getReseneObjaveByGradZa30Dana(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneObjaveByGrad(long idGrad)
        {
            var objave = _IObjaveBL.getReseneObjaveByGrad(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getNereseneObjaveByGrad(long idGrad)
        {
            var objave = _IObjaveBL.getNereseneObjaveByGrad(idGrad);
            return izlistajSveObjave(objave, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<TopGradovi> topGradoviPoObjavama()
        {
            var objave = _IObjaveBL.getAllObjave();
            var niz = from o in objave
                      group o by o.grad into objava
                      select new TopGradovi
                      {
                          nazivGrada = objava.Key.naziv_grada_lat,
                          idGrada = objava.Key.id,
                          ukupno = objave.Where(o1 => o1.GradID == objava.Key.id).Count()

                      };
          /*  var nizObjava = from o in niz
                            select new TopGradovi
                            {
                                nazivGrada = o.nazivGrada,
                                idGrada = o.idGrada,
                                ukupno = niz.Where(n => n.idGrada == o.idGrada).Count()

                            };*/

            List<TopGradovi> lista = niz.OrderByDescending(o => o.ukupno).Take(6).ToList();
            TopGradovi gradovi = new TopGradovi();
            gradovi.nazivGrada = "ostalo";
            var prvih6 = niz.OrderByDescending(o => o.ukupno).Take(6).Sum(o => o.ukupno);
            gradovi.ukupno = niz.Sum(o => o.ukupno);
            gradovi.ukupno = gradovi.ukupno - prvih6;
            lista.Add(gradovi);
            return lista;
        }

        public List<SveObjave> getNereseneObjaveByGradIKategorije(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getNereseneObjaveByGrad(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();

        }
        public List<SveObjave> getObjaveByIdKategorije(List<long> kategorija)
        {
            List<Objave> listaObjava = new List<Objave>();
            foreach(var id in kategorija)
            {
                var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(id);
                listaObjava.AddRange(objave);

            }
            return this.izlistajSveObjave(listaObjava, 0).OrderByDescending(o => o.vreme).ToList();
        }
        public List<SveObjave> getObjaveByIdKategorije(long kategorija)
        {
            List<Objave> listaObjava = new List<Objave>();
            if (kategorija == 0)
            {
                listaObjava = _IObjaveBL.getAllObjave();
            }
            else
            {
                    var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(kategorija);
                    listaObjava.AddRange(objave);
                
            }
            return this.izlistajSveObjave(listaObjava, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneObjaveByGradIKategorije(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getReseneObjaveByGrad(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> prikaziObjavePoKategorijamaZaKorisnika(PrihvatanjeKategorije data) //i resene i neresen prikazuje
        {
            // var listaNeresenih = _IObjaveUI.dajNeReseneProblemeZaInstituiju(data.idKorisnika).ToList();
            var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(data.kategorija);
            var lista = this.izlistajSveObjave(objave, data.idKorisnika).ToList();
            //   List<SveObjave> pocetna = listaNeresenih.Intersect(lista).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();

        }

        public List<SveObjave> prikaziPocetnuStranu(long idInstitucije)
        {
            List<KategorijeProblema> kategorije = _IInstitucijeKategorijeUI.getKategorijeByIdInstitucije(idInstitucije);
            List<Objave> listaObjava = new List<Objave>();
            var listaNeresenih = this.dajNeReseneProblemeZaInstituiju(idInstitucije).ToList();
            foreach (var kategorija in kategorije)
            {
                var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(kategorija.id);
                listaObjava.AddRange(objave);
            }
            var lista = this.izlistajSveObjave(listaObjava, idInstitucije).ToList();
            List<SveObjave> pocetna = listaNeresenih.Intersect(lista).ToList();
            return pocetna.OrderByDescending(o => o.vreme).ToList();
        }
        public List<SveObjave> prikaziReseneProblemPocetnuStranu(long idInstitucije)
        {
            List<KategorijeProblema> kategorije = _IInstitucijeKategorijeUI.getKategorijeByIdInstitucije(idInstitucije);
            List<Objave> listaObjava = new List<Objave>();
            var listaResenih = this.dajReseneProblemePocetneZaInstituiju(idInstitucije).ToList();
            foreach (var kategorija in kategorije)
            {
                var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(kategorija.id);
                listaObjava.AddRange(objave);
            }
            var lista = this.izlistajSveObjave(listaObjava, idInstitucije).ToList();
            List<SveObjave> pocetna = listaResenih.Intersect(lista).ToList();
            return pocetna.OrderByDescending(o => o.vreme).ToList();
           
        }

        public List<SveObjave> prikazNeresenihObjavaPoKategorijamaZaKorisnika(PrihvatanjeKategorije data)
        {
            var listaNeresenih = this.dajNeReseneProblemeZaInstituiju(data.idKorisnika).ToList();
            List<SveObjave> objave = new List<SveObjave>();
            if (data.kategorija == 0) objave = prikaziPocetnuStranu(data.idKorisnika);
            else
            {
                var lista = _IObjaveKategorijeUI.getObjavuByIdKategorije(data.kategorija);
                objave = this.izlistajSveObjave(lista, data.idKorisnika).ToList();
            }
      
            ///UBACI DA SE PRIKAZU SVE NERESENE ZA OVU KATEGORIJU!
     
            List<SveObjave> pocetna = listaNeresenih.Intersect(objave).ToList();
            return pocetna.OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> prikazResenihObjavaPoKategorijiZaKorisnika(PrihvatanjeKategorije data)
        {
            var listaNeresenih = this.dajReseneProblemePocetneZaInstituiju(data.idKorisnika).ToList();
            List<SveObjave> objave = new List<SveObjave>();
            if (data.kategorija == 0) objave = prikaziReseneProblemPocetnuStranu(data.idKorisnika);
            else
            {
                var lista = _IObjaveKategorijeUI.getObjavuByIdKategorije(data.kategorija);
                objave = this.izlistajSveObjave(lista, data.idKorisnika).ToList();
            }
  
            List<SveObjave> pocetna = listaNeresenih.Intersect(objave).ToList();
            return pocetna.OrderByDescending(o => o.vreme).ToList();
        }

        
        public StatistikaKategorije statistikaPoKategoriji(PrihvatanjeKategorije data)
        {
            StatistikaKategorije statistika = new StatistikaKategorije();
            if (data.kategorija != 0)
            {
                statistika.imeKategorije = this.getKategorijeProblema().FirstOrDefault(k => k.id == data.kategorija).kategorija;
            }
            else
            {
                statistika.imeKategorije = "Sve kategorije";
            }
            var objave = _IObjaveKategorijeUI.getObjavuByIdKategorije(data.kategorija);
           
            statistika.brojNeresenihProblema = objave.Where(o => o.resenaObjava == 0).Count();
            statistika.brojResenihProblema = objave.Where(o => o.resenaObjava > 0).Count();
            statistika.ukupnanBroj = statistika.brojResenihProblema + statistika.brojNeresenihProblema;
            return statistika;
        }

        public Statistika prikaziStatistiku(long idGrad, long kategorija)
        {
            var objaveNeresene = this.getNereseneObjaveByGrad(idGrad);
            var objaveResene = this.getReseneObjaveByGrad(idGrad);
            var objavePrijavljene = this.getReportovaneObjaveByGrada(idGrad);
            var statistika = napraviStatistiku(kategorija, idGrad, objaveNeresene, objaveResene, objavePrijavljene);
            statistika.brojKorisnika = _IGradKorisniciUI.getKorinsikeByIdGrada(idGrad).Count();
            statistika.brojGradjana = _IGradKorisniciUI.getGradjaneByIdGrada(idGrad).Count();
            statistika.brojInstitucija = statistika.brojKorisnika - statistika.brojGradjana;
            return statistika;
        }

        public Statistika prikaziStatistikuZa7Dana(long idGrad, long kategorija)
        {
            var objaveNeresene = this.getNereseneObjaveByGradZa7Dana(idGrad);
            var objaveResene = this.getReseneObjaveByGradZa7Dana(idGrad);
            var objavePrijavljene = this.getReportovaneObjaveByGradaZa7Dana(idGrad);
            return napraviStatistiku(kategorija, idGrad, objaveNeresene, objaveResene, objavePrijavljene);
        }

        public List<SveObjave> getNereseneObjaveByGradIKategorije7Dana(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getNereseneObjaveByGradZa7Dana(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReseneObjaveByGradIKategorije7Dana(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getReseneObjaveByGradZa7Dana(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> getReportovaneObjaveByGradIKategorija(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getReportovaneObjaveByGrada(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();

        }

        public Statistika prikaziStatistikuZa30Dana(long idGrad, long kategorija)
        {
            var objaveNeresene = this.getNereseneObjaveByGradZa30Dana(idGrad);
            var objaveResene = this.getReseneObjaveByGradZa30Dana(idGrad);
            var objavePrijavljene = this.getReportovaneObjaveByGradaZa30Dana(idGrad);
            return napraviStatistiku(kategorija, idGrad, objaveNeresene, objaveResene, objavePrijavljene);
        }

        private Statistika napraviStatistiku(long kategorija, long idGrad, List<SveObjave> objaveNeresene, List<SveObjave> objaveResene, List<SveObjave> objavePrijavljene)
        {
            Statistika statistika = new Statistika();
            statistika.idGrada = idGrad;

            //objave po kategorijama
            var objavePoKategorijama = this.getObjaveByIdKategorije(kategorija);

            statistika.brojNeresenihProblema = objavePoKategorijama.Intersect(objaveNeresene).ToList().Count();
            statistika.brojResenihProblema = objavePoKategorijama.Intersect(objaveResene).ToList().Count();
            statistika.brojPrijavljenihObjava = objavePoKategorijama.Intersect(objavePrijavljene).ToList().Count();
            statistika.ukupnanBroj = statistika.brojResenihProblema + statistika.brojNeresenihProblema;
            return statistika;
        }



        public List<SveObjave> getReportovaneObjaveByGradIKategorijaZa30Dana(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getReportovaneObjaveByGradaZa30Dana(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();

        }

        public List<SveObjave> getReportovaneObjaveByGradIKategorijaZa7Dana(long idGrada, long kategorija)
        {
            var listaPoGradovima = this.getReportovaneObjaveByGradaZa7Dana(idGrada);
            var listaPoKategorijama = this.getObjaveByIdKategorije(kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama).ToList();
            return lista.OrderByDescending(o => o.vreme).ToList();
        }

        public List<StatistikaKategorije> kategorijeSaNajviseObjava()
        {
            var objave = _IObjaveKategorijeUI.getAllObjaveKategorije();
            var niz = from o in objave
                      group o by o.kategorija into objava
                      select new StatistikaKategorije
                      {
                          imeKategorije = objava.Key.kategorija,
                          idKategorije = objava.Key.id,
                          ukupnanBroj = objave.Where(o1 => o1.KategorijaID == objava.Key.id).Count()

                      };
            /* var  nizObjava = from o in niz
                                   select new StatistikaKategorije
                                    {
                                      imeKategorije = o.imeKategorije,
                                      idKategorije = o.idKategorije,
                                      ukupnanBroj = niz.Where(n => n.idKategorije == o.idKategorije).Count()

                                   };*/

            var lista = niz.OrderByDescending(o => o.ukupnanBroj).Take(6).ToList();
            var prvih6 = niz.OrderByDescending(o => o.ukupnanBroj).Take(6).Sum(o => o.ukupnanBroj);
            StatistikaKategorije kategorija = new StatistikaKategorije();
            kategorija.imeKategorije = "ostalo";
            kategorija.ukupnanBroj = niz.Sum(o => o.ukupnanBroj) - prvih6;
            lista.Add(kategorija);
            return lista;
        }

        public StatistikaObjava tabelaObjava(long idGrada, long kategorija)
        {

            var objaveNeresene = this.getNereseneObjaveByGrad(idGrada);
            var objaveResene = this.getReseneObjaveByGrad(idGrada);
            return this.napraviStatistikuZaTabelu(kategorija, objaveNeresene, objaveResene);

        }

        public StatistikaObjava tabelaObjavaZa7Dana(long idGrada, long idKategorije)
        {

            var objaveNeresene = this.getNereseneObjaveByGradZa7Dana(idGrada);
            var objaveResene = this.getReseneObjaveByGradZa7Dana(idGrada);
            return this.napraviStatistikuZaTabelu(idKategorije, objaveNeresene, objaveResene);

        }

        public StatistikaObjava tabelaObjavaZa30dana(long idGrada, long idKategorije)
        {

            var objaveNeresene = this.getNereseneObjaveByGradZa30Dana(idGrada);
            var objaveResene = this.getReseneObjaveByGradZa30Dana(idGrada);
            return this.napraviStatistikuZaTabelu(idKategorije, objaveNeresene, objaveResene);

        }

        private StatistikaObjava napraviStatistikuZaTabelu(long kategorija, List<SveObjave> objaveNeresene, List<SveObjave> objaveResene)
        {
            StatistikaObjava statistika = new StatistikaObjava();
            var objavePoKategorijama = this.getObjaveByIdKategorije(kategorija);
            //za sve kategorije
            statistika.brojNeresenihObjava = objavePoKategorijama.Intersect(objaveNeresene).ToList().Count();

            if (statistika.brojNeresenihObjava > 0)
            {
                var brojLajkova = objaveNeresene.Sum(o => o.brojLajkova);
                statistika.prosecnaBrojLajkovaN = brojLajkova / statistika.brojNeresenihObjava;

                var brojDislajkova = objaveNeresene.Sum(o => o.brojDislajkova);
                statistika.prosecnaBrojDislajkovaN = brojDislajkova / statistika.brojNeresenihObjava;

                var brojReporta = objaveNeresene.Sum(o => o.brojReporta);
                statistika.prosecnaBrojPrijavaN = brojReporta / statistika.brojNeresenihObjava;

                var brojKomentara = objaveNeresene.Sum(o => o.brojKomentara);
                statistika.prosecnaBrojKomentaraN = brojKomentara / statistika.brojNeresenihObjava;
            }
            else
            {
                statistika.prosecnaBrojLajkovaN = 0;
                statistika.prosecnaBrojDislajkovaN = 0;
                statistika.prosecnaBrojPrijavaN = 0;
                statistika.prosecnaBrojKomentaraN = 0;
            }

            statistika.brojResenihObjava = objavePoKategorijama.Intersect(objaveResene).ToList().Count();

            if (statistika.brojResenihObjava > 0)
            {
                var brojLajkova = objaveResene.Sum(o => o.brojLajkova);
                statistika.prosecnaBrojLajkovaR = brojLajkova / statistika.brojResenihObjava;

                var brojDislajkova = objaveResene.Sum(o => o.brojDislajkova);
                statistika.prosecnaBrojDislajkovaR = brojDislajkova / statistika.brojResenihObjava;

                var brojReporta = objaveResene.Sum(o => o.brojReporta);
                statistika.prosecnaBrojPrijavaR = brojReporta / statistika.brojResenihObjava;

                var brojKomentara = objaveResene.Sum(o => o.brojKomentara);
                statistika.prosecnaBrojKomentaraR = brojKomentara / statistika.brojResenihObjava;
            }
            else
            {
                statistika.prosecnaBrojLajkovaR = 0;
                statistika.prosecnaBrojDislajkovaR = 0;
                statistika.prosecnaBrojPrijavaR = 0;
                statistika.prosecnaBrojKomentaraR = 0;
            }
            return statistika;
        }

     

        public List<SveObjave> dajObjaveZaAdmina(Pretraga data)
        {
            var listaPoGradovima = _IObjaveBL.getObjaveByIdGrada(data.grad);
            var listaPoKategorijama = _IObjaveKategorijeUI.getObjavuByIdKategorije(data.kategorija);
            var lista = listaPoGradovima.Intersect(listaPoKategorijama);
            return izlistajSveObjave(lista, 0).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> dajProfilInstituciji(PrihvatanjeIdKorisnika data)
        {
            var objave = _IObjaveBL.getObjaveByIdKorisnika(data.idKorisnika);
            return izlistajSveObjave(objave, data.aktivanKorisnik).OrderByDescending(o => o.vreme).ToList();
        }

        public List<SveObjave> daj10(PrihvatanjeIdKorisnika aktivanKorisnik)
        {
            List<long> nizGradova = _IGradKorisniciUI.getGradoveByIdKorisnika(aktivanKorisnik.idKorisnika);
            IEnumerable<Objave> objave = _IObjaveBL.getObjaveByIdGradova(nizGradova);
            var lista = izlistajSveObjave(objave, aktivanKorisnik.idKorisnika).OrderByDescending(o => o.vreme).ToList();
            int broj = aktivanKorisnik.index * 10;
            var novalista = lista.Take(broj).ToList();
            int brojOd = broj;
            if (aktivanKorisnik.index - 1 > 0)
            {
                 brojOd = (aktivanKorisnik.index - 1) * 10;
            }
           
            return novalista.TakeLast(brojOd).ToList();

        }
    }
}
