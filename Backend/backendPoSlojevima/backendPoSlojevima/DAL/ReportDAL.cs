using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL
{
    public class ReportDAL : IReportDAL
    {
        private readonly ApplicationDbContext _context;


        public ReportDAL(ApplicationDbContext context)
		{
			_context = context;
		}

        public void deleteReprot(List<Report> report)
        {
            if (report != null)
            {
                _context.report.RemoveRange(report);
                _context.SaveChanges();
            }
        }

        public List<Report> getAllReport()
        {
            return _context.report.ToList();
        }

        public List<RazlogPrijave> getRazlogePrijave()
        {
            return _context.razlog_prijave.ToList();
        }

        public int saveReport(Report data)
        {
            var check = _context.report.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
            if (check != null)  //unreport
            {
                return 0;
            }
            else //report
            {
                var checkLajk = _context.lajkovi.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkLajk != null)
                {
                    _context.lajkovi.Remove(checkLajk);
                }
                var checkDislajk = _context.dislajkovi.FirstOrDefault(l => l.KorisnikID == data.KorisnikID && l.ObjaveID == data.ObjaveID);
                if (checkDislajk != null)
                {
                    _context.dislajkovi.Remove(checkDislajk);
                }
                Report report = data;
               /* var id = _context.report.Count();
                if (id == 0)
                {
                    report.id =  1;
                }
                else
                {
                    report.id = _context.report.Max(o => o.id) + 1;
                    
                }*/
                _context.report.Add(report);
            } 
            _context.SaveChanges();
            return 1;
        }


        public List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave)
        {
            var reportovi = _context.report.Where(r => r.ObjaveID == idObjave);
            var lista = new List<KorisnikIRazlogPrijave>();

            foreach(var report in reportovi)
            {
                var k = _context.korisnik.FirstOrDefault(k => k.id == report.KorisnikID);
                KorisnikIRazlogPrijave korisnik = new KorisnikIRazlogPrijave();
                korisnik.id = k.id;
                korisnik.ime = k.ime;
                korisnik.prezime = k.prezime;
                korisnik.email = k.email;
                korisnik.biografija = k.biografija;
                korisnik.Token = k.Token;
                korisnik.poeni = k.poeni;
                korisnik.uloga = k.uloga;
                korisnik.urlSlike = k.urlSlike;
                korisnik.username = k.username;
                korisnik.password = k.password;

                korisnik.razlog = _context.razlog_prijave.FirstOrDefault( r => r.id == report.RazlogID).razlog;
                lista.Add(korisnik);
            }
            return lista;
        }
    }
}
