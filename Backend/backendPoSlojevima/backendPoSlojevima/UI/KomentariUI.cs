using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class KomentariUI : IKomentariUI
    {
        private readonly IKomentariBL _IKomentariBL;
        private readonly IKorisnikUI _IKorisnikUI;
        private readonly ILajkoviKomentaraUI _ILajkoviKomentaraUI;
        private readonly IDislajkoviKomentaraUI _IDislajkoviKomentaraUI;
        private readonly IReportKomentaraUI _IReportKomentaraUI;
        private readonly IGradKorisniciUI _IGradKorisniciUI;

        public KomentariUI(IGradKorisniciUI IGradKorisniciUI,IKomentariBL IKomentariBL, IKorisnikUI IKorisnikUI, ILajkoviKomentaraUI ILajkoviKomentaraUI, IDislajkoviKomentaraUI IDislajkoviKomentaraUI, IReportKomentaraUI IReportKomentaraUI)
        {
            _IKomentariBL = IKomentariBL;
            _IKorisnikUI = IKorisnikUI;
            _ILajkoviKomentaraUI = ILajkoviKomentaraUI;
            _IDislajkoviKomentaraUI = IDislajkoviKomentaraUI;
            _IReportKomentaraUI = IReportKomentaraUI;
            _IGradKorisniciUI = IGradKorisniciUI;
        }

        public List<Komentari> dajSveKomentareByIdObjave(PrihvatanjeIdObjave objava)
        {

            return _IKomentariBL.dajSveKomentareByIdObjave(objava.idObjave);
        }

        public void deleteKomentarByIdKomentara(PrihvatanjeIdKomentara komentar,int ind)
        {
         /*   _ILajkoviKomentaraUI.deleteLajkoveKomentaraByIdKomentara(komentar.idKomentara);
            _IDislajkoviKomentaraUI.deleteDislajkoveKomentaraByIdKomentara(komentar.idKomentara);
            _IReportKomentaraUI.deleteReportoveKomentaraByIdKomentara(komentar.idKomentara);*/
            _IKomentariBL.deleteKomentarByIdKomentara(komentar.idKomentara,ind);
        }

        public void deleteKomentareByIdKorisnika(long idKorisnika)
        {
            _ILajkoviKomentaraUI.deleteLajkoveKomentaraByIdKorisnika(idKorisnika);
            _IDislajkoviKomentaraUI.deleteDislajkoveKomentaraByIdKorisnika(idKorisnika);
            _IReportKomentaraUI.deleteReportoveKomentaraByIdKorisnika(idKorisnika);
            _IKomentariBL.deleteKomentareByIdKorisnika(idKorisnika);
        }

        public void deleteKomentareByIdObjave(long idObjave)
        {
            var listaKomentara = _IKomentariBL.getKomentareByIdObjave(idObjave);
            foreach(var komentara in listaKomentara)
            {
                _ILajkoviKomentaraUI.deleteLajkoveKomentaraByIdKomentara(komentara.id);
                _IDislajkoviKomentaraUI.deleteDislajkoveKomentaraByIdKomentara(komentara.id);
                _IReportKomentaraUI.deleteReportoveKomentaraByIdKomentara(komentara.id);
               
            }
            _IKomentariBL.deleteKomentareByIdObjave(idObjave);
        }

        public List<Komentari> getAllKomentari()
        {
            return _IKomentariBL.getAllKomentari();
        }

        public List<Komentari> getAllReseneProbleme()
        {
            return _IKomentariBL.getAllReseneProbleme();
        }
        public List<SveZaReseneProbleme> getReseneProblemeByIdObjave(PrihvatanjeIdObjave objava)
        {
            var reseniProblemi = _IKomentariBL.getReseneProblemeByIdObjave(objava.idObjave);
            var listaResenihProblema = new List<SveZaReseneProbleme>();
            foreach(var problem in reseniProblemi)
            {
                SveZaReseneProbleme newProblem = new SveZaReseneProbleme();
                newProblem.id = problem.id;
                newProblem.idObjave = problem.ObjaveID;
                newProblem.tekst = problem.tekst;
                newProblem.urlSlike = problem.urlSlike;
                newProblem.korisnik = _IKorisnikUI.getKorisnikaById(problem.KorisnikID);
                if(newProblem != null)
                {
                    listaResenihProblema.Add(newProblem);
                }
               
            }
            return listaResenihProblema;
        }


        public long getBrojKomentaraByIdObjave(PrihvatanjeIdObjave objava)
        {
            return _IKomentariBL.getBrojKomentaraByIdObjave(objava.idObjave);
        }

        public List<Komentari> getKomentareByIdObjave(long idObjave)
        {
            return _IKomentariBL.getKomentareByIdObjave(idObjave);
        }

        public List<Komentari> getKomentareByKorisnikId(PrihvatanjeIdKorisnika korisnika)
        {
            return _IKomentariBL.getKomentareByKorisnikId(korisnika.idKorisnika);
        }

        public void saveImage(PrihvatanjeSlikeKomentara image)
        {
            _IKomentariBL.saveImage(image);
        }

        public void saveKomentar(PrihvatanjeKomentara data)
        {
            int resenProblem = data.resenProblem;
            int poslataSlika = data.poslataSlika;
            _IKomentariBL.saveKomentar(data,poslataSlika,resenProblem);
        }
        
        
        public List<SveZaKomentare> sveZaKomentare(PrihvatanjeKomentara data)
        {
            List<SveZaKomentare> komentariSaKorisnicima = new List<SveZaKomentare>();
            var objava = new PrihvatanjeIdObjave();
            objava.idObjave = data.idObjave;
            var listaKomentara = _IKomentariBL.dajSveKomentareByIdObjave(objava.idObjave);
            foreach (var komentar in listaKomentara)
            {
                SveZaKomentare newKomentar = new SveZaKomentare();
                newKomentar.id = komentar.id;
                newKomentar.idObjave = komentar.ObjaveID;
                newKomentar.tekst = komentar.tekst;
                newKomentar.urlSlike = komentar.urlSlike;
                newKomentar.brojLajkova= _ILajkoviKomentaraUI.getBrojLajkovaByIdKomentara(komentar.id);
                newKomentar.brojDislajkova = _IDislajkoviKomentaraUI.getBrojDislajkovaByIdKomentara(komentar.id);
                newKomentar.brojReporta = _IReportKomentaraUI.getBrojReportaByIdKomentara(komentar.id);
                newKomentar.resenProblem = komentar.resenProblem;
                newKomentar.oznacenKaoResen = komentar.oznacenKaoResen;
                var korisnik = _IKorisnikUI.getKorisnikaById(komentar.KorisnikID);
                var vlasnikObjave = new KorisnikSaGradovima();
                vlasnikObjave.id = korisnik.id;
                vlasnikObjave.ime = korisnik.ime;
                vlasnikObjave.prezime = korisnik.prezime;
                vlasnikObjave.poeni = korisnik.poeni;
                vlasnikObjave.Token = korisnik.Token;
                vlasnikObjave.uloga = korisnik.uloga;
                vlasnikObjave.username = korisnik.username;
                vlasnikObjave.password = korisnik.password;
                vlasnikObjave.urlSlike = korisnik.urlSlike;
                vlasnikObjave.biografija = korisnik.biografija;
                vlasnikObjave.gradovi = _IGradKorisniciUI.getAllGradoveByIdKorisnika(korisnik.id);
                newKomentar.korisnik = vlasnikObjave;
                // proveriAktivnost(data.idKorisnika, newKomentar, komentar);
                var aktivanKorisnik = data.idKorisnika;
                newKomentar.aktivanKorisnikLajkovao = _ILajkoviKomentaraUI.getLajkKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
                newKomentar.aktivanKorisnikDislajkovao = _IDislajkoviKomentaraUI.getDislajkKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
                newKomentar.aktivanKorisnikReportovao = _IReportKomentaraUI.getReportKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
                if (newKomentar != null)
                {
                    komentariSaKorisnicima.Add(newKomentar);
                }
               
            }
            komentariSaKorisnicima.Reverse();
            return komentariSaKorisnicima;
        }

        private void proveriAktivnost(long  aktivanKorisnik, SveZaKomentare newKomentar, Komentari komentar)
        {
            newKomentar.aktivanKorisnikLajkovao = _ILajkoviKomentaraUI.getLajkKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
            newKomentar.aktivanKorisnikDislajkovao = _IDislajkoviKomentaraUI.getDislajkKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
            newKomentar.aktivanKorisnikReportovao = _IReportKomentaraUI.getReportKomentaraByIdKorisnika(aktivanKorisnik, komentar.id);
        }

        public Komentari problemResen(PrihvatanjeIdKomentara komentara)
        {
            return _IKomentariBL.problemResen(komentara.idKomentara);
        }

        public List<SveZaReseneProbleme> getOznacenaReseneProblemeByIdObjave(PrihvatanjeIdObjave objava)
        {
            var reseniProblemi = _IKomentariBL.getOznaceneKaoReseniProblemiByIdObjave(objava.idObjave);
            var listaResenihProblema = new List<SveZaReseneProbleme>();
            foreach (var problem in reseniProblemi)
            {
                SveZaReseneProbleme newProblem = new SveZaReseneProbleme();
                newProblem.id = problem.id;
                newProblem.idObjave = problem.ObjaveID;
                newProblem.tekst = problem.tekst;
                newProblem.korisnik = _IKorisnikUI.getKorisnikaById(problem.KorisnikID);
                newProblem.urlSlike = problem.urlSlike;
                if(problem != null)
                {
                    listaResenihProblema.Add(newProblem);
                }
                
            }
            return listaResenihProblema;

        }

        public void problemResenSaViseKomentara(PrihvatanjeNizaKomentara idKomentara)
        {
            List<Komentari> komentari = new List<Komentari>();
            foreach(var kom in idKomentara.idKomentara)
            {
                var komentar = _IKomentariBL.getKomentarByIdKomentara(kom);
                if (komentar != null)
                {
                    komentari.Add(komentar);
                }
               
            }

            foreach (var item in komentari)
            {
                _IKomentariBL.problemResen(item.id);
            }
        }

        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika)
        {
            return _IKomentariBL.saveResenjeInstitucije(slika);
        }

        public Komentari izmenaKomentara(Komentari izmena)
        {
            return _IKomentariBL.izmenaKomentara(izmena);
        }
    }
}
