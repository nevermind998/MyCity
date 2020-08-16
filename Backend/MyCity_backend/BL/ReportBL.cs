using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class ReportBL : IReportBL
    {
        private readonly IReportDAL _IReportDAL;
        private readonly IKorisnikBL _IKorisnikBL;
        private readonly List<Report> reportovi;
        private readonly IObjaveBL _IObjaveBL;

        public ReportBL(IReportDAL IReportDAL, IKorisnikBL IKorisnikBL, IObjaveBL IObjaveBL)
        {
            _IReportDAL = IReportDAL;
            reportovi = _IReportDAL.getAllReport();
            _IKorisnikBL = IKorisnikBL;
            _IObjaveBL = IObjaveBL;
        }

        public long brojReportovaZaVlasnikaObjava(long idKorisnika)
        {
            var objave = _IObjaveBL.getObjaveByIdKorisnika(idKorisnika);
            List<Report> listaReportova = new List<Report>();
            long brojReportovanihObjava = 0;
            foreach (var objava in objave)
            {
                var report = getReportoveByIdObjave(objava.id);
                if (report.Count() > 0)
                {
                    brojReportovanihObjava++;
                }
                //  brojReportova += report.Count();
            }

            // if (objave.Count() < brojReportovanihObjava) brojReportovanihObjava *= 4;
            return brojReportovanihObjava;
        }


        public long dajSveReportoveByIdObjave(long idObjave)
        {
            var pokupiReportove = reportovi.Where(r => r.ObjaveID == idObjave);
            long brojReporta = pokupiReportove.Count();
            return brojReporta;
        }

        public void deleteReportoveByIdKorisnika(long idKorisnika)
        {
            List<Report> listaReporta = getReportoveByKoirsnikId(idKorisnika);
            // foreach(var report in listaReporta)
            {
                _IReportDAL.deleteReprot(listaReporta);
            }
        }

        public void deleteReportoveByIdObjave(long idObjave)
        {
            List<Report> listaReporta = getReportoveByIdObjave(idObjave);
            //  foreach (var report in listaReporta)
            {
                _IReportDAL.deleteReprot(listaReporta);
            }
        }

        public List<Report> getAllReport()
        {
            return _IReportDAL.getAllReport();
        }

        public List<Korisnik> getKorisnikeKojiReportujuByIdObjave(long idObjave)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = reportovi.Where(o => o.ObjaveID == idObjave);
            foreach (var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public List<RazlogPrijave> getRazlogePrijave()
        {
            return _IReportDAL.getRazlogePrijave();
        }

        public int getReportByKorisnikId(long idKorisnika, long idObjave)
        {
            var check = reportovi.FirstOrDefault(l => l.ObjaveID == idObjave && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }

        public List<Objave> getReportovaneObjave()
        {
            return reportovi.Select(r => r.objave).ToList();
        }

        public List<Objave> getReportovaneObjaveByIdGrada(long idGrada)
        {
            if (idGrada == 0)
            {
                return reportovi.Select(r => r.objave).ToList();
            }
            else
            {
                return reportovi.Where(r => r.objave.GradID == idGrada).Select(r => r.objave).ToList();
            }
        }

        public List<Objave> getReportovaneObjaveByIdGrada7Dana(long idGrada)
        {
            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-7);
            if (idGrada == 0)
            {
                return reportovi.Where(o => o.objave.vreme >= datum).Select(r => r.objave).ToList();
            }
            else
            {

                return reportovi.Where(r => r.objave.GradID == idGrada && r.objave.vreme >= datum).Select(r => r.objave).ToList();
            }
        }
        public List<Objave> getReportovaneObjaveByIdGrada30Dana(long idGrada)
        {
            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-30);
            if (idGrada == 0)
            {
                return reportovi.Where(o => o.objave.vreme >= datum).Select(r => r.objave).ToList();
            }
            else
            {

                return reportovi.Where(r => r.objave.GradID == idGrada && r.objave.vreme >= datum).Select(r => r.objave).ToList();
            }
        }

        public List<Report> getReportoveByIdObjave(long idObjave)
        {
            return reportovi.Where(r => r.ObjaveID == idObjave).ToList();
        }

        public List<Report> getReportoveByKoirsnikId(long idKorisnika)
        {
            return reportovi.Where(r => r.KorisnikID == idKorisnika).ToList();
        }

        public long maxReportova()
        {
            var niz = from r in reportovi
                      group r by r.objave into objave
                      select new
                      {
                          idKorinsika = objave.Key.KorisnikID,
                          ukupno = 1

                      };
            var nizBrojeva = from r in niz
                             select new
                             {
                                 idKorinsika = r.idKorinsika,
                                 ukupno = niz.Where(k => k.idKorinsika == r.idKorinsika).Count()

                             };

            var maxBroj = nizBrojeva.Max(m => m.ukupno);
            return maxBroj;
        }



        public int saveReport(Report report)
        {
            return _IReportDAL.saveReport(report);
        }

        public List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave)
        {
            return _IReportDAL.getKorisnikeIRazlogPrijave(idObjave);
        }
    }
}
